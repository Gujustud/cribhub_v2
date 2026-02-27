import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pocketbase_service.dart';
import 'app_config.dart';

class ToolImportConfigScreen extends StatefulWidget {
  const ToolImportConfigScreen({super.key});

  @override
  State<ToolImportConfigScreen> createState() => _ToolImportConfigScreenState();
}

class _ToolImportConfigScreenState extends State<ToolImportConfigScreen> {
  bool _isLoading = true;
  bool _mcpServerOnline = false;
  String? _error;
  List<dynamic> _brandsWithScrapers = [];
  
  final String _mcpServerUrl = AppConfig.mcpUrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check MCP server health
      final healthResponse = await http.get(
        Uri.parse('$_mcpServerUrl/health'),
      ).timeout(const Duration(seconds: 5));

      final mcpOnline = healthResponse.statusCode == 200;

      // Load brands with scraping enabled
      final pbService = PocketBaseService();
      final allBrands = await pbService.getBrands();
      
      // Filter to only brands with scraping enabled
      final brandsWithScrapers = allBrands.where((brand) {
        return brand.data['scraper_enabled'] == true;
      }).toList();

      setState(() {
        _mcpServerOnline = mcpOnline;
        _brandsWithScrapers = brandsWithScrapers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _mcpServerOnline = false;
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tool Import Configuration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // MCP Server Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _mcpServerOnline ? Icons.check_circle : Icons.error,
                                color: _mcpServerOnline ? Colors.green : Colors.red,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'MCP Server Status',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _mcpServerOnline ? 'Online and Ready' : 'Offline',
                                      style: TextStyle(
                                        color: _mcpServerOnline ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: _loadData,
                                tooltip: 'Refresh status',
                              ),
                            ],
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Error:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _error!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Make sure the MCP server is running:\npython mcp_server.py',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            'Server URL: $_mcpServerUrl',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Configured Brands Section
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'CONFIGURED BRANDS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/brands');
                        },
                        icon: const Icon(Icons.settings, size: 18),
                        label: const Text('Manage Brands'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  if (_brandsWithScrapers.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No brands configured for auto-import',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Go to Brands screen and enable auto-import for brands you want to use',
                              style: TextStyle(color: Colors.grey.shade500),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/brands');
                              },
                              icon: const Icon(Icons.factory),
                              label: const Text('Go to Brands'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._brandsWithScrapers.map((brand) {
                      final name = brand.data['name'] ?? 'Unknown';
                      final urlPattern = brand.data['url_pattern'] ?? '';
                      final notes = brand.data['scraper_notes'] ?? '';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.factory, color: Colors.blue),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                urlPattern,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (notes.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  notes,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                          trailing: const Icon(Icons.check_circle, color: Colors.green),
                          onTap: () {
                            Navigator.pushNamed(context, '/brands');
                          },
                        ),
                      );
                    }).toList(),
                  
                  const SizedBox(height: 24),
                  
                  // How to Use Section
                  const Text(
                    'HOW TO USE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInstructionStep(
                            '1',
                            'Enable auto-import for brands in Brand Management',
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionStep(
                            '2',
                            'Create or edit a tool',
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionStep(
                            '3',
                            'Select a brand with auto-import enabled',
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionStep(
                            '4',
                            'Enter the model number',
                          ),
                          const SizedBox(height: 12),
                          _buildInstructionStep(
                            '5',
                            'Click "Import" to auto-fill specifications',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(text),
          ),
        ),
      ],
    );
  }
}
