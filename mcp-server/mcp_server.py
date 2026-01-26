#!/usr/bin/env python3
"""
MCP Server for Tool Specification Extraction
Uses Ollama (Qwen2.5) to extract tool specs from vendor websites
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import httpx
import json
import os
from typing import Optional, Dict, Any
import re
from bs4 import BeautifulSoup

app = FastAPI(title="CribHub Tool Import MCP Server")

# Add CORS middleware to allow PocketBase to call this
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your PocketBase domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configuration
OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "llama3.2:3b")

class ToolImportRequest(BaseModel):
    brand: str
    url: str  # Direct URL to the tool page

class ToolSpecsResponse(BaseModel):
    success: bool
    data: Optional[Dict[str, Any]] = None
    error: Optional[str] = None
    source_url: Optional[str] = None

async def fetch_webpage(url: str) -> str:
    """Fetch webpage content"""
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=30.0) as client:
            response = await client.get(url)
            response.raise_for_status()
            return response.text
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch webpage: {str(e)}")

async def extract_specs_with_ollama(html_content: str, brand: str) -> Dict[str, Any]:
    """Use Ollama (Qwen2.5) to extract tool specifications from HTML"""
    
    # STEP 1: Clean the HTML using BeautifulSoup
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Remove unwanted elements that add noise
    for element in soup(['script', 'style', 'nav', 'header', 'footer', 'iframe']):
        element.decompose()
    
    # Get clean text
    clean_text = soup.get_text(separator='\n', strip=True)
    
    # Look for "Tool Dimensions" or similar sections and prioritize that area
    lines = clean_text.split('\n')
    start_index = 0
    for i, line in enumerate(lines):
        if any(keyword in line.lower() for keyword in ['tool dimension', 'product specification', 'specifications', 'dimensions']):
            # Start from a few lines before this heading
            start_index = max(0, i - 2)
            break
    
    # Take content starting from that section (or beginning if not found)
    relevant_text = '\n'.join(lines[start_index:start_index + 150])  # ~150 lines should be enough
    
    # Limit to reasonable size
    if len(relevant_text) > 6000:
        relevant_text = relevant_text[:6000]
    
    # STEP 2: Create clear prompt with examples
    prompt = f"""You are extracting cutting tool specifications from a {brand} webpage.

CRITICAL LABEL MAPPINGS (extract the NUMBER after these labels):
- "Cutter Diameter" → diameter_in (this is the main cutting diameter)
- "Diameter" → diameter_in (if no "Cutter Diameter" found)
- "Length of Cut" → flute_length (this is the cutting length)
- "Flute Length" → flute_length (alternate label)
- "Number of Flutes" or "Flutes" → flutes
- "Overall Length" or "OAL" → overall_length
- "Corner Radius" or "Corner Rad" → corner_rad
- "Shank Diameter" → shank_diameter
- "Neck Diameter" or "Neck" → neck
- "Coating" → coating
- "Material" → material

CONVERSION EXAMPLES (including very small decimals):
Input: "Cutter Diameter: 0.0080" (.2 mm)"  → diameter_in: 0.0080, diameter_mm: 0.2
Input: "Cutter Diameter: 1.5 inch"         → diameter_in: 1.5
Input: "Diameter: 1/2""                    → diameter_in: 0.5
Input: "Diameter: 3/4 in"                  → diameter_in: 0.75
Input: "Length of Cut: 0.0240""            → flute_length: 0.0240
Input: "Length of Cut: 0.75"               → flute_length: 0.75
Input: "Number of Flutes: 8"               → flutes: 8
Input: "Flutes: 4"                         → flutes: 4
Input: "Overall Length: 1.5000" (1-1/2)"   → overall_length: 1.5
Input: "Overall Length: 24 in"             → overall_length: 24.0
Input: "Shank Diameter: 0.1250" (1/8)"     → shank_diameter: 0.125
Input: "Corner Radius: 0.5""               → corner_rad: 0.5
Input: "Coating: UN"                       → coating: "UN"
Input: "Material: HSS"                     → material: "HSS"

IMPORTANT RULES:
1. Extract EXACT decimal values including very small ones like 0.0080 or 0.0240
2. Convert fractions to decimals: 1/2=0.5, 1/4=0.25, 3/4=0.75, 1/8=0.125, 3/8=0.375, 5/8=0.625, 7/8=0.875
3. Remove all units (", in, mm, inch) from numbers but keep the number itself
4. Use null if value not found (not "Not found" or empty string)
5. Return ONLY valid JSON, no explanation

Return JSON with these exact fields:
{{
  "diameter_in": number or null,
  "diameter_mm": number or null,
  "flutes": integer or null,
  "flute_length": number or null,
  "overall_length": number or null,
  "corner_rad": number or null,
  "shank_diameter": number or null,
  "neck": number or null,
  "coating": string or null,
  "material": string or null
}}

Webpage content:
{relevant_text}

JSON response:"""

    try:
        async with httpx.AsyncClient(timeout=60.0) as client:
            response = await client.post(
                f"{OLLAMA_BASE_URL}/api/generate",
                json={
                    "model": OLLAMA_MODEL,
                    "prompt": prompt,
                    "stream": False,
                    "options": {
                        "temperature": 0.1,  # Low temperature for consistent extraction
                        "top_p": 0.9,
                    }
                }
            )
            response.raise_for_status()
            result = response.json()
            
            # Extract the generated text
            generated_text = result.get("response", "")
            
            # Clean up the response - remove markdown code blocks if present
            cleaned = generated_text.strip()
            cleaned = re.sub(r'^```json\s*', '', cleaned)
            cleaned = re.sub(r'^```\s*', '', cleaned)
            cleaned = re.sub(r'\s*```$', '', cleaned)
            cleaned = cleaned.strip()
            
            # Parse JSON
            try:
                specs = json.loads(cleaned)
                
                # Post-process: ensure numeric types are correct
                numeric_fields = ['diameter_in', 'diameter_mm', 'flute_length', 'overall_length', 
                                'corner_rad', 'shank_diameter', 'neck']
                for field in numeric_fields:
                    if field in specs and specs[field] is not None:
                        try:
                            specs[field] = float(specs[field])
                        except (ValueError, TypeError):
                            specs[field] = None
                
                if 'flutes' in specs and specs['flutes'] is not None:
                    try:
                        specs['flutes'] = int(specs['flutes'])
                    except (ValueError, TypeError):
                        specs['flutes'] = None
                
                return specs
                
            except json.JSONDecodeError as e:
                # Log the error for debugging
                print(f"❌ JSON PARSING ERROR:")
                print(f"   Error: {str(e)}")
                print(f"   Raw LLM response (first 500 chars):")
                print(f"   {cleaned[:500]}")
                print(f"   ---")
                
                # If JSON parsing fails, return error with the raw response for debugging
                raise HTTPException(
                    status_code=500, 
                    detail=f"Failed to parse LLM response as JSON: {str(e)}. Raw response: {cleaned[:200]}"
                )
                
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=f"Ollama API error: {str(e)}")

@app.get("/")
async def root():
    """Health check endpoint"""
    return {
        "status": "online",
        "service": "CribHub Tool Import MCP Server",
        "ollama_url": OLLAMA_BASE_URL,
        "model": OLLAMA_MODEL
    }

@app.get("/health")
async def health_check():
    """Check if Ollama is accessible"""
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(f"{OLLAMA_BASE_URL}/api/tags")
            response.raise_for_status()
            return {"status": "healthy", "ollama": "connected"}
    except Exception as e:
        return {"status": "degraded", "ollama": "disconnected", "error": str(e)}

@app.post("/api/extract-tool-specs", response_model=ToolSpecsResponse)
async def extract_tool_specs(request: ToolImportRequest):
    """
    Extract tool specifications from vendor website
    
    Accepts:
    - brand: Brand name (for logging/context)
    - url: Direct URL to the tool page
    """
    
    url = request.url
    if not url:
        raise HTTPException(
            status_code=400,
            detail="URL is required"
        )
    
    try:
        # Fetch the webpage
        print(f"🔍 Fetching URL: {url}")
        html_content = await fetch_webpage(url)
        print(f"✅ Fetched {len(html_content)} characters of HTML")
        
        # Extract specs using Ollama
        print(f"🤖 Extracting specs with {OLLAMA_MODEL}...")
        specs = await extract_specs_with_ollama(html_content, request.brand)
        print(f"✅ Extraction successful!")
        
        return ToolSpecsResponse(
            success=True,
            data=specs,
            source_url=url
        )
        
    except HTTPException:
        raise
    except Exception as e:
        # Log the full error for debugging
        import traceback
        print(f"❌ ERROR during extraction:")
        print(f"   URL: {url}")
        print(f"   Brand: {request.brand}")
        print(f"   Error: {str(e)}")
        print(f"   Traceback:")
        traceback.print_exc()
        
        return ToolSpecsResponse(
            success=False,
            error=str(e),
            source_url=url if 'url' in locals() else None
        )

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", "8001"))
    uvicorn.run(app, host="0.0.0.0", port=port)
