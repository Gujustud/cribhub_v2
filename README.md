# CribHub - Shop Tool Inventory Management

A modern, cross-platform inventory management system for workshop tools built with Flutter and PocketBase.

## 🎯 Overview

CribHub helps workshop technicians efficiently track and manage tool inventory. From tool crib storage to machine locations, CribHub provides real-time visibility into tool locations, quantities, and movement history.

## 🛠️ Technology Stack

- **Frontend**: Flutter (Material Design 3)
- **Backend**: PocketBase (lightweight backend-as-a-service)
- **Database**: SQLite (via PocketBase)
- **Platforms**: Web, Desktop, Mobile
- **State Management**: Built-in Flutter state management

## ✨ Features

### 🔍 Inventory Management
- **Real-time search** across tool names, brands, models, and categories
- **Hierarchical location tracking** (Toolbox → Drawer → Bin)
- **Quantity management** with automatic stock level indicators
- **Category-based organization** (Cutting Tools, Workholding, Inspection, Misc)

### 🔄 Tool Movement Tracking
- **Transfer tools** between locations with quantity tracking
- **Movement history** with timestamps and user tracking
- **Location validation** to prevent invalid transfers
- **Bulk operations** for efficient inventory management

### 📱 User Experience
- **Cross-platform compatibility** (Web, Desktop, Mobile)
- **Responsive design** that works on any screen size
- **Intuitive interface** with drag-and-drop simplicity
- **Real-time updates** via PocketBase subscriptions

### 🏭 Workshop Integration
- **Machine-specific tool tracking** (CNC machines, manual tools)
- **Return tool workflows** for end-of-shift operations
- **Barcode/QR code support** (infrastructure ready)
- **Supplier and brand management**

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.10.0 or higher)
- **Dart SDK** (included with Flutter)
- **PocketBase** (included in project)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/cribhub.git
   cd cribhub
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Start PocketBase backend**
   ```bash
   cd pocketbase
   ./pocketbase.exe serve
   ```
   PocketBase will run at `http://127.0.0.1:8090`

4. **Run the Flutter app**
   ```bash
   # For web
   flutter run -d chrome

   # For Windows desktop
   flutter run -d windows

   # For other platforms
   flutter run
   ```

## 📁 Project Structure

```
cribhub/
├── lib/                    # Flutter source code
│   ├── main.dart          # App entry point
│   ├── models.dart        # Data models
│   ├── pocketbase_service.dart  # Backend service layer
│   ├── tool_list_screen.dart   # Main inventory screen
│   ├── add_tool_screen.dart    # Tool creation screen
│   ├── transfer_dialog.dart    # Tool transfer dialog
│   └── [other screens...]
├── pocketbase/            # PocketBase backend
│   ├── pb_data/          # Database files
│   ├── pb_migrations/    # Database migrations
│   └── pocketbase.exe    # PocketBase binary
├── web/                  # Web platform files
├── windows/              # Windows platform files
├── android/              # Android platform files
├── ios/                  # iOS platform files
└── pubspec.yaml          # Flutter dependencies
```

## 🗃️ Database Schema

### Collections

- **tools**: Tool catalog with specifications
- **locations**: Hierarchical storage locations
- **tool_locations**: Junction table for tool quantities at locations
- **movement_history**: Transfer tracking with timestamps
- **brands**: Tool manufacturer brands
- **suppliers**: Tool suppliers and vendors

### Key Relationships

- Tools can exist in multiple locations with different quantities
- Locations support parent-child hierarchy (Toolbox → Drawer → Bin)
- Movement history tracks all transfers with full audit trail

## 🔧 Development

### Adding New Features

1. **Backend changes**: Create migrations in `pb_migrations/`
2. **Frontend changes**: Update models and UI in `lib/`
3. **Testing**: Run on multiple platforms to ensure compatibility

### Building for Production

**Local dev (default)**  
The app uses `http://localhost:8090` (PocketBase) and `http://localhost:8001` (MCP) when no defines are set. Just run `flutter run -d chrome` or `flutter build web` for local testing.

**Production web build (deploy to server)**  
Set the server URLs at build time so the deployed app talks to your live backend:

```bash
flutter build web --dart-define=POCKETBASE_URL=https://cribhub.sscadcam.com/ --dart-define=MCP_URL=https://cribhub.sscadcam.com/mcp
```

Then zip the contents of `build/web/` (not the `web` folder) as `dist.zip`, serve it from your laptop, and on the server download and unzip into the web root (e.g. `/opt/pocketbase/pb_public`). See deploy notes or run scripts if available.

```bash
# Other platforms
flutter build windows
flutter build apk   # Android
flutter build ios   # iOS
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/cribhub/issues)
- **Documentation**: See inline code comments and this README
- **PocketBase Docs**: [pocketbase.io/docs](https://pocketbase.io/docs)

## 🎉 Acknowledgments

- Built with [Flutter](https://flutter.dev)
- Powered by [PocketBase](https://pocketbase.io)
- Material Design 3 components

---

**CribHub** - Making workshop inventory management simple and efficient! 🔧✨
