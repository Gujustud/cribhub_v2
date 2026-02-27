/// App URLs - set at build time via --dart-define.
/// Local dev (default): localhost:8090 / localhost:8001
/// Production build: flutter build web --dart-define=POCKETBASE_URL=https://cribhub.sscadcam.com/ --dart-define=MCP_URL=https://cribhub.sscadcam.com/mcp
class AppConfig {
  static const String pocketBaseUrl = String.fromEnvironment(
    'POCKETBASE_URL',
    defaultValue: 'http://localhost:8090',
  );

  static const String mcpUrl = String.fromEnvironment(
    'MCP_URL',
    defaultValue: 'http://localhost:8001',
  );
}
