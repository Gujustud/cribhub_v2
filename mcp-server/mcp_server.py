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

async def extract_deboer_specs(model_number: str) -> Dict[str, Any]:
    """Extract specs from DeBoer Tool API (direct JSON, no AI needed!)"""
    try:
        api_url = f"https://deboertool.com/api/products/{model_number}"
        print(f"🔍 Fetching DeBoer API: {api_url}")
        
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.get(api_url)
            response.raise_for_status()
            data = response.json()
        
        print(f"✅ Got DeBoer API response")
        
        # The response has structure: { "data": { "spec": {...} }, "user": {...} }
        # We need to get the product data from inside "data"
        product_data = data.get('data', {})
        
        # DEBUG: Print the structure
        print(f"🔍 DEBUG - Product data keys: {list(product_data.keys())[:10]}")
        
        # Extract spec object from product data
        spec = product_data.get('spec', {})
        
        # Map DeBoer fields to our standard fields
        specs = {
            'diameter_in': None,
            'diameter_mm': None,
            'flutes': None,
            'flute_length': None,
            'overall_length': None,
            'corner_rad': None,
            'shank_diameter': None,
            'neck': None,
            'coating': None,
            'material': None,
        }
        
        # Cutting diameter
        if 'linear:cutting-diameter' in spec:
            specs['diameter_in'] = spec['linear:cutting-diameter'].get('value')
            specs['diameter_mm'] = spec['linear:cutting-diameter'].get('valueMm')
        
        # Flutes
        if 'integer:flutes' in spec:
            specs['flutes'] = spec['integer:flutes'].get('value')
        
        # Flute length (cutting length)
        if 'linear:cutting-length' in spec:
            specs['flute_length'] = spec['linear:cutting-length'].get('value')
        
        # Overall length
        if 'linear:overall-length' in spec:
            specs['overall_length'] = spec['linear:overall-length'].get('value')
        
        # Shank diameter
        if 'linear:shank-diameter' in spec:
            specs['shank_diameter'] = spec['linear:shank-diameter'].get('value')
        
        # Corner radius (DeBoer calls it "radius-size")
        if 'linear:radius-size' in spec:
            specs['corner_rad'] = spec['linear:radius-size'].get('value')
        elif 'linear:corner-radius' in spec:
            specs['corner_rad'] = spec['linear:corner-radius'].get('value')
        
        # Coating (if they have it)
        if 'string:coating' in spec:
            specs['coating'] = spec['string:coating'].get('value')
        
        # Material (if they have it)
        if 'string:material' in spec:
            specs['material'] = spec['string:material'].get('value')
        
        print(f"✅ Extracted {sum(1 for v in specs.values() if v is not None)} fields from DeBoer API")
        return specs
        
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=f"DeBoer API error: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error parsing DeBoer data: {str(e)}")

def extract_dixi_specs_from_js(html_content: str, sku: str) -> Dict[str, Any]:
    """Extract specs from Dixi's JavaScript JSON object (no AI needed!)"""
    try:
        import json
        import re
        
        print(f"🔍 Searching for JavaScript JSON data for SKU {sku}")
        
        # DEBUG: Check if the variable exists at all
        if 'encodedChildrenTechnicalData' in html_content:
            print(f"✅ Variable name found in HTML")
            # Find where it appears
            pos = html_content.find('encodedChildrenTechnicalData')
            context = html_content[max(0, pos-100):pos+200]
            print(f"📍 Context around variable: {context[:300]}")
        else:
            print(f"❌ Variable 'encodedChildrenTechnicalData' NOT found in HTML")
            # Check for alternative names
            alternatives = ['technical', 'product', 'children', 'variation']
            for alt in alternatives:
                if alt in html_content.lower():
                    count = html_content.lower().count(alt)
                    print(f"   - Found '{alt}' {count} times")
        
        # Find the encodedChildrenTechnicalData JSON object
        # It's in a script tag like: const encodedChildrenTechnicalData = JSON.parse("{...}");
        # Try different patterns
        patterns = [
            r'const encodedChildrenTechnicalData = JSON\.parse\("(.+?)"\);',
            r'const encodedChildrenTechnicalData = JSON\.parse\(\"(.+?)\"\);',
            r'encodedChildrenTechnicalData = JSON\.parse\("(.+?)"\)',
            r'encodedChildrenTechnicalData = JSON\.parse\(\'(.+?)\'\)',
        ]
        
        match = None
        for pattern in patterns:
            match = re.search(pattern, html_content, re.DOTALL)
            if match:
                print(f"✅ Found data with pattern: {pattern[:50]}...")
                break
        
        if not match:
            # Try to find it without regex - just search for the variable name
            start_marker = 'encodedChildrenTechnicalData'
            start_pos = html_content.find(start_marker)
            if start_pos != -1:
                # Find the opening quote after JSON.parse(
                parse_pos = html_content.find('JSON.parse(', start_pos)
                if parse_pos != -1:
                    quote_pos = html_content.find('"', parse_pos)
                    if quote_pos != -1:
                        # Find the closing quote and parenthesis
                        # Look for "); or ");
                        end_marker_1 = '");'
                        end_marker_2 = "\");"
                        end_pos_1 = html_content.find(end_marker_1, quote_pos + 1)
                        end_pos_2 = html_content.find(end_marker_2, quote_pos + 1)
                        end_pos = min([p for p in [end_pos_1, end_pos_2] if p != -1], default=-1)
                        
                        if end_pos != -1:
                            json_str = html_content[quote_pos + 1:end_pos]
                            print(f"✅ Found data manually (length: {len(json_str)} chars)")
                        else:
                            print(f"❌ Could not find end marker")
                            raise HTTPException(
                                status_code=500,
                                detail="Could not find product data in page"
                            )
                    else:
                        print(f"❌ Could not find opening quote")
                        raise HTTPException(
                            status_code=500,
                            detail="Could not find product data in page"
                        )
                else:
                    print(f"❌ Could not find JSON.parse(")
                    raise HTTPException(
                        status_code=500,
                        detail="Could not find product data in page"
                    )
            else:
                print(f"❌ Could not find encodedChildrenTechnicalData in HTML")
                raise HTTPException(
                    status_code=500,
                    detail="Could not find product data in page"
                )
        else:
            json_str = match.group(1)
        # Unescape the JSON string
        json_str = json_str.encode().decode('unicode_escape')
        
        # Parse the JSON
        products_data = json.loads(json_str)
        print(f"✅ Found data for {len(products_data)} products")
        
        # Find the product by matching SKU in the data
        product_id = None
        for pid, pdata in products_data.items():
            # The product data is nested, we need to check all variations
            # Just use the first product for now - we'll need to match by SKU properly
            product_id = pid
            break
        
        if not product_id:
            raise HTTPException(
                status_code=500,
                detail=f"Could not find product data for SKU {sku}"
            )
        
        product = products_data[product_id]
        print(f"📦 Using product ID: {product_id}")
        
        # Map Dixi fields to our standard fields
        specs = {
            'diameter_in': None,
            'diameter_mm': None,
            'flutes': None,
            'flute_length': None,
            'overall_length': None,
            'corner_rad': None,
            'shank_diameter': None,
            'neck': None,
            'coating': None,
            'material': None,
            'thread_size': None,
        }
        
        # Extract diameter (D1) - convert mm to inches
        if 'dixi_variation_d1' in product and 'value' in product['dixi_variation_d1']:
            d1_mm = float(product['dixi_variation_d1']['value'])
            specs['diameter_in'] = round(d1_mm / 25.4, 4)
            specs['diameter_mm'] = d1_mm
        
        # Extract flutes (Z)
        if 'dixi_variation_z' in product and 'value' in product['dixi_variation_z']:
            specs['flutes'] = int(product['dixi_variation_z']['value'])
        
        # Extract flute length (L1) - convert mm to inches
        if 'dixi_variation_l1' in product and 'value' in product['dixi_variation_l1']:
            l1_mm = float(product['dixi_variation_l1']['value'])
            specs['flute_length'] = round(l1_mm / 25.4, 4)
        
        # Extract overall length (L) - convert mm to inches
        if 'dixi_variation_l' in product and 'value' in product['dixi_variation_l']:
            l_mm = float(product['dixi_variation_l']['value'])
            specs['overall_length'] = round(l_mm / 25.4, 4)
        
        # Extract shank diameter (D) - convert mm to inches
        if 'dixi_variation_d' in product and 'value' in product['dixi_variation_d']:
            d_mm = float(product['dixi_variation_d']['value'])
            specs['shank_diameter'] = round(d_mm / 25.4, 4)
        
        # Extract thread size (D nom)
        if 'dixi_variation_d_nom' in product and 'value' in product['dixi_variation_d_nom']:
            d_nom = product['dixi_variation_d_nom']['value']
            # Also get pitch (Pas) and combine them
            if 'dixi_variation_pas' in product and 'value' in product['dixi_variation_pas']:
                pas = product['dixi_variation_pas']['value']
                specs['thread_size'] = f"{d_nom}x{pas}"
            else:
                specs['thread_size'] = d_nom
        
        # Extract coating
        if 'dixi_variation_revetement' in product and 'value' in product['dixi_variation_revetement']:
            coating = product['dixi_variation_revetement']['value']
            # Convert "Sans" to "Uncoated"
            if coating.lower() == 'sans':
                coating = 'Uncoated'
            specs['coating'] = coating
        
        print(f"✅ Extracted {sum(1 for v in specs.values() if v is not None)} fields from Dixi JavaScript")
        return specs
        
    except json.JSONDecodeError as e:
        print(f"❌ JSON parsing error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error parsing Dixi JSON: {str(e)}")
    except Exception as e:
        print(f"❌ Error extracting Dixi data: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error extracting Dixi data: {str(e)}")

async def extract_specs_with_ollama(html_content: str, brand: str) -> Dict[str, Any]:
    """Use Ollama (Qwen2.5) to extract tool specifications from HTML"""
    
    # STEP 1: Clean the HTML using BeautifulSoup
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Remove unwanted elements that add noise
    for element in soup(['script', 'style', 'nav', 'header', 'footer', 'iframe']):
        element.decompose()
    
    # Get clean text
    clean_text = soup.get_text(separator='\n', strip=True)
    
    print(f"🧹 DEBUG - After BeautifulSoup:")
    print(f"   - Clean text length: {len(clean_text)} chars")
    print(f"   - First 500 chars: {clean_text[:500]}")
    print(f"   - Search for 'Technical data': {'FOUND' if 'technical data' in clean_text.lower() else 'NOT FOUND'}")
    print(f"   - Search for 'Technical': {'FOUND' if 'technical' in clean_text.lower() else 'NOT FOUND'}")
    import sys
    sys.stdout.flush()
    
    # Look for "Tool Dimensions" or similar sections and prioritize that area
    lines = clean_text.split('\n')
    start_index = 0
    keywords_found = []
    for i, line in enumerate(lines):
        if any(keyword in line.lower() for keyword in ['tool dimension', 'technical data', 'product specification', 'specifications', 'dimensions']):
            # Start from a few lines before this heading
            start_index = max(0, i - 2)
            keywords_found.append((i, line.strip()[:100]))  # Store line number and preview
            break
    
    print(f"🔍 DEBUG - Keyword search:")
    print(f"   - Total lines: {len(lines)}")
    print(f"   - Keywords found: {keywords_found if keywords_found else 'NONE'}")
    print(f"   - Start index: {start_index}")
    import sys
    sys.stdout.flush()
    
    # Take content starting from that section (or beginning if not found)
    relevant_text = '\n'.join(lines[start_index:start_index + 150])  # ~150 lines should be enough
    
    # Limit to reasonable size
    if len(relevant_text) > 6000:
        relevant_text = relevant_text[:6000]
    
    # STEP 2: Create clear prompt with examples
    prompt = f"""You are extracting cutting tool specifications from a {brand} webpage.

CRITICAL LABEL MAPPINGS (extract the NUMBER after these labels):
- "Cutter Diameter" or "Flute Diameter" or "D1" or "D 1" → diameter_in (this is the main cutting diameter, often VERY SMALL like 0.0080" or 0.0620")
- "Diameter" → diameter_in (if no "Cutter Diameter" or "Flute Diameter" found)
- "Length of Cut" or "Flute Length" or "Flutes Length" or "L1" or "L 1" → flute_length (this is the cutting length, often small like 0.0240" or 0.0930")
- "Number of Flutes" or "Flutes" or "Z" → flutes
- "Overall Length" or "OAL" or "L" → overall_length
- "Corner Radius" or "Corner Rad" → corner_rad
- "Shank Diameter" or "D h5" or "D h6" → shank_diameter
- "Neck Diameter" or "Neck" or "Overall Reach" → neck (the reach or neck dimension)
- "Coating" or "Revetement" → coating (note: "Sans" means "Uncoated")
- "Material" → material
- "D nom" or "Thread Size" or "Thread Designation" → thread_size (e.g., "M1.20", "M2.0")

CONVERSION EXAMPLES (PAY SPECIAL ATTENTION TO SMALL DECIMALS):
Input: "Cutter Diameter: 0.0080" (.2 mm)"       → diameter_in: 0.0080, diameter_mm: 0.2
Input: "Flute Diameter: 0.1875"                → diameter_in: 0.1875
Input: "Cutter Diameter: 0.0620" (1/16)"       → diameter_in: 0.0620
Input: "Cutter Diameter 0.0620" (1/16)"        → diameter_in: 0.0620
Input: "Cutter Diameter: 1.5 inch"             → diameter_in: 1.5
Input: "Diameter: 1/2""                        → diameter_in: 0.5
Input: "Diameter: 1/16 in"                     → diameter_in: 0.0625
Input: "Diameter: 3/32""                       → diameter_in: 0.09375
Input: "Length of Cut: 0.0240""                → flute_length: 0.0240
Input: "Length of Cut: 0.0930" (3/32)"         → flute_length: 0.0930
Input: "Length of Cut 0.0930" (3/32)"          → flute_length: 0.0930
Input: "Flutes Length: 0.5625"                 → flute_length: 0.5625
Input: "Length of Cut: 0.75"                   → flute_length: 0.75
Input: "Number of Flutes: 8"                   → flutes: 8
Input: "Flutes: 3"                             → flutes: 3
Input: "Overall Length: 1.5000" (1-1/2)"       → overall_length: 1.5
Input: "Overall Length: 2.5000" (2-1/2)"       → overall_length: 2.5
Input: "Overall Length: 24 in"                 → overall_length: 24.0
Input: "Shank Diameter: 0.1250" (1/8)"         → shank_diameter: 0.125
Input: "Overall Reach: 0.1400" (9/64)"        → neck: 0.1400
Input: "Neck Diameter: 0.25"                  → neck: 0.25
Input: "Corner Radius: 0.5""                   → corner_rad: 0.5
Input: "Coating: UN"                           → coating: "UN"
Input: "Coating: Sans"                         → coating: "Uncoated"
Input: "Coating: MAYURA"                       → coating: "MAYURA"
Input: "Material: Carbide"                     → material: "Carbide"
Input: "D nom: M1.20"                          → thread_size: "M1.20"
Input: "D1: 1.0"                               → diameter_in: 0.0394 (if mm context, convert: 1.0 / 25.4)
Input: "L1: 3.6"                               → flute_length: 0.1417 (if mm context, convert: 3.6 / 25.4)
Input: "L: 38.0"                               → overall_length: 1.496 (if mm context, convert: 38.0 / 25.4)
Input: "D h5: 3.0"                             → shank_diameter: 0.1181 (if mm context, convert: 3.0 / 25.4)
Input: "Z: 1"                                  → flutes: 1

IMPORTANT RULES:
1. EXTRACT EXACT DECIMAL VALUES including very small ones like 0.0080, 0.0240, 0.0620, 0.0930
2. The number comes RIGHT AFTER the label, before any parentheses or units
3. Example: "Cutter Diameter: 0.0620" (1/16)" → extract 0.0620, ignore (1/16)
4. Convert standalone fractions to decimals: 1/2=0.5, 1/4=0.25, 3/4=0.75, 1/8=0.125, 1/16=0.0625, 3/32=0.09375
5. If values are in millimeters (mm), convert to inches by dividing by 25.4
6. Remove all units (", in, mm, inch) from numbers but keep the number itself
7. Use null if value not found (not "Not found" or empty string)
8. Return ONLY valid JSON, no explanation

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
  "material": string or null,
  "thread_size": string or null
}}

Webpage content:
{relevant_text}

JSON response:"""

    print(f"📊 DEBUG - Prompt stats:")
    print(f"   - Relevant text length: {len(relevant_text)} chars")
    print(f"   - Full prompt length: {len(prompt)} chars")
    print(f"   - First 200 chars of relevant text: {relevant_text[:200]}")
    import sys
    sys.stdout.flush()

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
            
            print(f"✅ Got response from Ollama")
            print(f"   - Response keys: {list(result.keys())}")
            import sys
            sys.stdout.flush()
            
            # Extract the generated text
            generated_text = result.get("response", "")
            
            # Clean up the response - remove markdown code blocks if present
            cleaned = generated_text.strip()
            cleaned = re.sub(r'^```json\s*', '', cleaned)
            cleaned = re.sub(r'^```\s*', '', cleaned)
            cleaned = re.sub(r'\s*```$', '', cleaned)
            cleaned = cleaned.strip()
            
            # Extract just the JSON object (ignore any text after the closing brace)
            # Find the first { and last } to extract only the JSON
            first_brace = cleaned.find('{')
            if first_brace != -1:
                # Find the matching closing brace
                brace_count = 0
                for i in range(first_brace, len(cleaned)):
                    if cleaned[i] == '{':
                        brace_count += 1
                    elif cleaned[i] == '}':
                        brace_count -= 1
                        if brace_count == 0:
                            # Found the closing brace
                            cleaned = cleaned[first_brace:i+1]
                            break
            
            print(f"🔍 DEBUG - JSON extraction:")
            print(f"   - Cleaned response length: {len(cleaned)} chars")
            print(f"   - First 200 chars: {cleaned[:200]}")
            import sys
            sys.stdout.flush()
            
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
        import sys
        print(f"❌ OLLAMA API ERROR:")
        print(f"   Error: {str(e)}")
        print(f"   Traceback:")
        import traceback
        traceback.print_exc()
        sys.stdout.flush()
        sys.stderr.flush()
        raise HTTPException(status_code=500, detail=f"Ollama API error: {str(e)}")
    except Exception as e:
        import sys
        print(f"❌ UNEXPECTED ERROR in extract_specs_with_ollama:")
        print(f"   Error: {str(e)}")
        print(f"   Error type: {type(e).__name__}")
        print(f"   Traceback:")
        import traceback
        traceback.print_exc()
        sys.stdout.flush()
        sys.stderr.flush()
        raise HTTPException(status_code=500, detail=f"Unexpected error: {str(e)}")

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
        # Check if this is Dixi - extract from JavaScript JSON
        if 'dixipolytool.ch' in url.lower():
            print(f"🎯 Detected Dixi Polytool - extracting from JavaScript JSON")
            
            # Extract SKU from URL
            # URL format: https://dixipolytool.ch/dixi-1740?sku=985136
            import re
            match = re.search(r'[?&]sku=([^&]+)', url)
            if not match:
                raise HTTPException(
                    status_code=400,
                    detail="Could not extract SKU from Dixi URL"
                )
            
            sku = match.group(1)
            print(f"📦 SKU: {sku}")
            
            # Fetch the page
            print(f"🔍 Fetching URL: {url}")
            html_content = await fetch_webpage(url)
            print(f"✅ Fetched {len(html_content)} characters of HTML")
            
            # Extract specs from JavaScript JSON
            specs = extract_dixi_specs_from_js(html_content, sku)
            
            return ToolSpecsResponse(
                success=True,
                data=specs,
                source_url=url
            )
        
        # Check if this is DeBoer Tool - use their API directly!
        if 'deboertool.com' in url.lower():
            print(f"🎯 Detected DeBoer Tool - using API extraction")
            
            # Extract model number from URL
            # URL format: https://deboertool.com/app/products/110-0156-4AR10
            import re
            match = re.search(r'/products/([^/]+)$', url)
            if not match:
                raise HTTPException(
                    status_code=400,
                    detail="Could not extract model number from DeBoer URL"
                )
            
            model_number = match.group(1)
            print(f"📦 Model number: {model_number}")
            
            # Use DeBoer API (no AI needed!)
            specs = await extract_deboer_specs(model_number)
            
            return ToolSpecsResponse(
                success=True,
                data=specs,
                source_url=url
            )
        
        # For other brands (Harvey Tool, etc) - use HTML + AI extraction
        print(f"🔍 Fetching URL: {url}")
        html_content = await fetch_webpage(url)
        print(f"✅ Fetched {len(html_content)} characters of HTML")
        
        # Extract specs using Ollama
        print(f"🤖 Extracting specs with {OLLAMA_MODEL}...")
        import sys
        sys.stdout.flush()  # Force output before potentially long operation
        specs = await extract_specs_with_ollama(html_content, request.brand)
        print(f"✅ Extraction successful!")
        sys.stdout.flush()
        
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
