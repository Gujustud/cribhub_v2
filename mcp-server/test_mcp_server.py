#!/usr/bin/env python3
"""
Test script for CribHub MCP Tool Import Server
Run this to verify everything is working before integrating with Flutter
"""

import httpx
import json
import sys

MCP_SERVER_URL = "http://localhost:8001"
TEST_BRAND = "harvey"
TEST_MODEL = "814193"

def print_section(title):
    """Print a section header"""
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}\n")

def test_health():
    """Test MCP server health endpoint"""
    print_section("Testing MCP Server Health")
    try:
        response = httpx.get(f"{MCP_SERVER_URL}/health", timeout=5.0)
        data = response.json()
        print(f"✅ Server Status: {data.get('status', 'unknown')}")
        print(f"✅ Ollama Connection: {data.get('ollama', 'unknown')}")
        return True
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        print("\nMake sure:")
        print("  1. MCP server is running (python mcp_server.py)")
        print("  2. Ollama is running (ollama list)")
        return False


def test_tool_import():
    """Test actual tool import with Harvey Tool model 814193"""
    print_section(f"Testing Tool Import: Harvey Tool #814193")
    
    print("This will:")
    print("  1. Fetch the webpage from Harvey Tool")
    print("  2. Extract specs using Ollama/Qwen2.5")
    print("  3. Return structured JSON data")
    print("\nThis may take 5-10 seconds on first run...\n")
    
    try:
        # Build the Harvey Tool URL
        model_number = "814193"
        url = f"https://www.harveytool.com/products-en-ca/en-ca-tool-details-{model_number}"
        
        request_data = {
            "brand": "Harvey Tool",
            "url": url
        }
        
        print(f"Sending request to: {MCP_SERVER_URL}/api/extract-tool-specs")
        print(f"Request data: {json.dumps(request_data, indent=2)}\n")
        
        response = httpx.post(
            f"{MCP_SERVER_URL}/api/extract-tool-specs",
            json=request_data,
            timeout=60.0  # Give it time to process
        )
        
        if response.status_code == 200:
            data = response.json()
            
            if data.get('success'):
                print("✅ Import successful!\n")
                print("Extracted Data:")
                print("-" * 40)
                
                tool_data = data.get('data', {})
                for key, value in tool_data.items():
                    if value is not None:
                        print(f"  {key:20s} : {value}")
                    else:
                        print(f"  {key:20s} : (not found)")
                
                print("-" * 40)
                print(f"\nSource URL: {data.get('source_url', 'N/A')}")
                
                # Validate expected fields
                print("\nValidation:")
                expected_fields = ['diameter_in', 'flutes', 'flute_length']
                all_present = True
                for field in expected_fields:
                    if tool_data.get(field) is not None:
                        print(f"  ✅ {field} is present")
                    else:
                        print(f"  ⚠️  {field} is missing")
                        all_present = False
                
                if all_present:
                    print("\n✅ All critical fields extracted successfully!")
                else:
                    print("\n⚠️  Some fields are missing - this is okay, not all tools have all specs")
                
                return True
            else:
                print(f"❌ Import failed: {data.get('error', 'Unknown error')}")
                return False
        else:
            print(f"❌ Server returned status code: {response.status_code}")
            print(f"Response: {response.text[:200]}")
            return False
            
    except httpx.TimeoutException:
        print("❌ Request timed out - this might be normal on first run")
        print("   The model needs to load into memory first time")
        print("   Try running the test again!")
        return False
    except Exception as e:
        print(f"❌ Import test failed: {e}")
        return False

def main():
    """Run all tests"""
    print("\n" + "="*60)
    print("  CribHub MCP Server Test Suite")
    print("="*60)
    
    results = {
        "Health Check": test_health(),
        "Tool Import": test_tool_import(),
    }
    
    print_section("Test Results Summary")
    
    all_passed = True
    for test_name, result in results.items():
        status = "✅ PASSED" if result else "❌ FAILED"
        print(f"{test_name:25s} : {status}")
        if not result:
            all_passed = False
    
    print("\n" + "="*60)
    if all_passed:
        print("🎉 All tests passed! The MCP server is ready to use.")
        print("You can now integrate it with your Flutter app.")
    else:
        print("⚠️  Some tests failed. Please check the errors above.")
        print("\nCommon issues:")
        print("  • MCP server not running: python mcp_server.py")
        print("  • Ollama not running: ollama serve")
        print("  • Qwen2.5 not installed: ollama pull qwen2.5:1.5b")
    print("="*60 + "\n")
    
    return 0 if all_passed else 1

if __name__ == "__main__":
    sys.exit(main())
