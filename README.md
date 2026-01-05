# Link4Fun - Smart Link Manager App 📱

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.19.0-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0.0-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![Version](https://img.shields.io/badge/Version-1.0.0-orange)

**Hello**

</div>

## ✨ **v1.0.0**

### 🔍 **Smart Search with Highlighting**
- Real-time search with text highlighting
- Search across titles and URLs simultaneously
- Search results counter with beautiful badge
- Clean search UI with clear textbox design

### 📱 **QR Code Generator**
- Generate QR codes for any link instantly
- Customizable QR code colors matching link theme
- Copy QR code URL with one tap
- Share QR codes easily

### 🎨 **Enhanced UI/UX**
- Smooth animations and transitions
- Staggered card animations
- Modern Material Design 3 interface
- Improved dark/light theme support
- Gradient backgrounds and better shadows

### ⚡ **Performance Improvements**
- Optimized state management
- Better error handling
- Persistent search state
- Improved data synchronization

## 📋 **Complete Feature List**

| Category | Features |
|----------|----------|
| **Link Management** | ✅ Add, Edit, Delete links<br>✅ One-tap URL opening<br>✅ Copy URL to clipboard<br>✅ Persistent local storage |
| **Search & Organization** | ✅ Real-time search with highlighting<br>✅ Filter by title or URL<br>✅ Search results counter<br>✅ Clean search interface |
| **QR Code Features** | ✅ Generate QR codes for any link<br>✅ Customizable QR colors<br>✅ Copy QR code URL<br>✅ Share functionality |
| **UI/UX** | ✅ Smooth animations<br>✅ Dark/Light themes<br>✅ Gradient backgrounds<br>✅ Responsive design<br>✅ Confirmation dialogs |
| **Technical** | ✅ Flutter 3.19.0+<br>✅ Material Design 3<br>✅ SharedPreferences storage<br>✅ URL launching<br>✅ Clipboard support |

## 🚀 **Quick Start**

### **Prerequisites**
- Flutter SDK 3.19.0 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code (optional)

### **Installation Steps**

1. **Clone the repository**
   ```bash
   git clone https://github.com/richky0/Link4Fun.git
   cd Link4Fun
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android
   flutter run
   
   # For specific device
   flutter run -d <device_id>
   
   # For release mode
   flutter run --release
   ```

## 🏗️ **Project Architecture**

```
lib/
├── main.dart                  # Main application with all features
│
├── Model Components:
│   ✓ Link model class
│   ✓ Color helper functions
│   ✓ JSON serialization
│
├── Service Layer:
│   ✓ LinkService for data management
│   ✓ SharedPreferences integration
│   ✓ Default links setup
│
├── UI Components:
│   ✓ Search AppBar
│   ✓ Link Cards with animations
│   ✓ QR Code Dialog
│   ✓ Bottom Sheet Options
│   ✓ Confirmation Dialogs
│
├── Features:
│   ✓ Search with highlighting
│   ✓ QR Code generation
│   ✓ Link CRUD operations
│   ✓ URL launching
│   ✓ Clipboard integration
│
└── Utilities:
    ✓ Animation controllers
    ✓ Snackbar notifications
    ✓ Error handling
    ✓ Focus management
```

## 🎯 **Usage Guide**

### **Adding Links**
1. Tap the **+** icon in the AppBar
2. Enter title and URL
3. URL automatically gets `https://` prefix if missing
4. Tap **Add Link** to save

### **Using Search**
1. Tap the **search icon** in AppBar
2. Type in the search box
3. Results appear in real-time with highlighted matches
4. Tap **X** to clear search or **←** to exit search mode

### **Generating QR Codes**
1. Tap **QR Code icon** on any link card
2. View the generated QR code
3. Use buttons to:
   - **Copy URL** to clipboard
   - **Open Link** in browser
   - **Close** the dialog

### **Link Options (Three-dot menu)**
- **Generate QR Code** - Create QR for sharing
- **Open Link** - Launch in default browser
- **Copy URL** - Copy to clipboard
- **Edit Link** - Modify title/URL
- **Delete Link** - Remove with confirmation

### **Quick Actions**
- **Tap card** - Open link
- **Long press card** - Show options menu
- **Refresh icon** - Reload links
- **Add icon** - Create new link

## 🔧 **Configuration**

### **Default Links**
The app comes with 8 default links for demonstration:
- Google, YouTube, GitHub, Twitter
- Instagram, Facebook, LinkedIn, Netflix

### **Customizing Colors**
Each link gets a unique color based on:
```dart
int getColorValue(int r, int g, int b) {
  return (0xFF << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
}
```

### **Theme Settings**
Modify in `main.dart`:
```dart
theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, // Change theme color
    brightness: Brightness.light,
  ),
),
```

## 📦 **Dependencies**

| Package | Version | Purpose |
|---------|---------|---------|
| `shared_preferences` | ^2.2.0 | Persistent local storage |
| `url_launcher` | ^6.1.0 | Opening URLs in browser |
| `qr_flutter` | ^4.1.0 | QR code generation |
| `path_provider` | ^2.0.0 | File system access |
| `flutter` | SDK | Core framework |

## 🚀 **Building for Release**

### **Android APK**
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# Release build with split per ABI
flutter build apk --release --split-per-abi
```

### **Android App Bundle**
```bash
flutter build appbundle --release
```

### **Install Release APK**
```bash
# After building, install with:
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 🎨 **UI Components Details**

### **Search AppBar**
- Clean white background with rounded bottom
- Integrated search field with clear button
- Back button for exiting search
- Results counter badge

### **Link Cards**
- Gradient backgrounds matching link colors
- Smooth entry animations (staggered)
- Rounded corners with subtle shadows
- QR Code and options icons

### **QR Code Dialog**
- Custom dialog with scale animation
- Link information display
- Action buttons (Copy, Open)
- Color-matched UI elements

### **Bottom Sheet**
- Smooth slide-up animation
- Icon-based options
- Color-coded actions
- Keyboard-aware padding

## 🔍 **Search Implementation**

### **Real-time Filtering**
```dart
List<Link> _filteredLinks = _allLinks.where((link) {
  return link.title.toLowerCase().contains(query.toLowerCase()) ||
         link.url.toLowerCase().contains(query.toLowerCase());
}).toList();
```

### **Text Highlighting**
- Matched text gets blue highlight
- Background color for emphasis
- Bold font weight for matches
- Case-insensitive search

### **Search State Management**
- Maintains search query during navigation
- Preserves filtered results
- Handles keyboard interactions
- Clean exit from search mode

## 📱 **Platform Support**

| Platform | Status | Notes |
|----------|--------|-------|
| **Android** | ✅ Fully Supported | API 21+ (Android 5.0+) |
| **iOS** | ⚠️ Limited Testing | Requires macOS for build |
| **Web** | ⚠️ Experimental | URL launching limitations |
| **Windows** | 🔄 Planned | Future release |
| **macOS** | 🔄 Planned | Future release |
| **Linux** | 🔄 Planned | Future release |

## 🐛 **Bug Fixes in v2.0.0**

### **Fixed Issues**
1. **List disappearance** after closing dialogs/bottom sheets
2. **Search state conflicts** with FutureBuilder
3. **Keyboard overlap** with bottom sheets
4. **Missing delete confirmation** dialog
5. **AppBar type safety** issues in build
6. **State synchronization** problems
7. **Empty state handling** improvements
8. **Animation controller** management

### **Performance Improvements**
- Optimized rebuild cycles
- Better memory management
- Smoother animations
- Reduced unnecessary renders

## 🔮 **Roadmap & Future Features**

### **v2.1.0 (Planned)**
- [ ] **Categories/Tags** for links
- [ ] **Import/Export** functionality
- [ ] **Cloud Sync** with Firebase
- [ ] **Link previews** with og:image
- [ ] **Custom icons** selection

### **v2.2.0 (Ideas)**
- [ ] **Password protection** for app
- [ ] **Biometric authentication**
- [ ] **Widget for home screen**
- [ ] **Backup to Google Drive**
- [ ] **Statistics and analytics**

### **v2.3.0 (Long-term)**
- [ ] **Cross-platform sync**
- [ ] **Browser extension**
- [ ] **API for developers**
- [ ] **Themes marketplace**
- [ ] **Team collaboration**

## 🧪 **Testing**

### **Manual Test Cases**
1. Add new link with valid URL
2. Edit existing link title/URL
3. Delete link with confirmation
4. Search functionality with various queries
5. QR code generation and sharing
6. URL launching in browser
7. Copy to clipboard verification
8. Theme switching (dark/light)

### **Automated Tests** (Planned)
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

## 🤝 **Contributing**

We welcome contributions! Here's how to help:

### **Reporting Bugs**
1. Check existing issues
2. Create detailed bug report
3. Include steps to reproduce
4. Add screenshots if possible

### **Feature Requests**
1. Check roadmap
2. Explain use case
3. Suggest implementation
4. Discuss in issues

### **Pull Requests**
1. Fork the repository
2. Create feature branch
3. Add tests if applicable
4. Update documentation
5. Submit PR with description

### **Development Setup**
```bash
# 1. Fork and clone
git clone https://github.com/YOUR_USERNAME/Link4Fun.git

# 2. Create branch
git checkout -b feature/your-feature

# 3. Make changes and test
flutter run

# 4. Commit and push
git commit -m "Add your feature"
git push origin feature/your-feature

# 5. Create Pull Request
```

## 📝 **Code Quality**

### **Best Practices Followed**
- ✅ Null safety (Dart 3.0)
- ✅ Material Design 3 guidelines
- ✅ Responsive design principles
- ✅ State management patterns
- ✅ Error handling throughout
- ✅ Performance optimization

### **Code Style**
- Consistent naming conventions
- Proper documentation
- Modular architecture
- Separation of concerns
- Reusable components

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 **Author**

**Richky Sung**
- GitHub: [@richky0](https://github.com/richky0)
- Email: richky61@gmail.com

## 🙏 **Acknowledgments**

- **Flutter Team** for the incredible framework
- **Material Design Team** for the design system
- **QR Flutter package** maintainers
- **All contributors** and testers
- **Open source community** for inspiration

## ⭐ **Support & Feedback**

If you find this project useful, please:

1. **Star** the repository on GitHub
2. **Share** with your network
3. **Report** any issues you encounter
4. **Suggest** improvements and features
5. **Contribute** code or documentation

---

<div align="center">


</div>
