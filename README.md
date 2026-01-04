# Link4Fun - Link Manager App 📱

<div align="center">
  
![Flutter](https://img.shields.io/badge/Flutter-3.19.0-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0.0-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

A modern and beautiful Flutter application for managing your favorite links with one tap!

</div>

## 📸 Screenshots

<div align="center">
  <img src="https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Home+Screen" alt="Home Screen" width="200"/>
  <img src="https://via.placeholder.com/300x600/4CAF50/FFFFFF?text=Add+Link" alt="Add Link" width="200"/>
  <img src="https://via.placeholder.com/300x600/FF9800/FFFFFF?text=Link+Options" alt="Link Options" width="200"/>
</div>

## ✨ Features

- 🔗 **One-tap link opening** - Open your favorite websites instantly
- 📋 **Copy URL to clipboard** - Easy sharing and saving
- ➕ **Add new links** - Customize with titles, URLs, and icons
- ✏️ **Edit existing links** - Update your links anytime
- 🗑️ **Delete links** - Remove unwanted links with swipe gesture
- 🎨 **Beautiful UI** - Modern Material Design 3 with dark/light theme
- 💾 **Local storage** - Links saved locally with SharedPreferences
- 🔄 **Cross-platform** - Works on Android, iOS, and Web

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.19.0 or higher
- Dart 3.0.0 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/RichkySung/link4fun.git
   cd link4fun
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android
   flutter run -d android
   
   # For iOS (requires macOS)
   flutter run -d ios
   
   # For Web
   flutter run -d chrome
   ```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### Web
```bash
flutter build web --release
```

## 🏗️ Project Structure

```
link4fun/
├── lib/
│   ├── main.dart              # Main application entry point
│   ├── models/
│   │   └── link.dart          # Link data model
│   ├── services/
│   │   └── link_service.dart  # Link storage and management
│   └── widgets/               # Reusable UI components
├── assets/
│   └── icons/
│       └── app_icon.png       # Application icon
├── android/                   # Android specific files
├── ios/                      # iOS specific files
└── web/                      # Web specific files
```

## 🎯 Usage

### Adding a Link
1. Tap the **+ Add Link** floating button
2. Enter the link title
3. Enter the URL (with or without https://)
4. Tap **Add Link**

### Managing Links
- **Tap** a link to open it in your browser
- **Long press** or tap the **⋮ menu** for options:
  - Open Link
  - Copy URL
  - Edit Link
  - Delete Link
- **Swipe left** to delete a link quickly

### Copying URLs
When you copy a URL, you'll get a confirmation snackbar showing:
- ✅ Check icon
- "Link Copied!" message
- The copied URL (truncated if too long)

## 🛠️ Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `shared_preferences` | ^2.2.0 | Local data storage |
| `url_launcher` | ^6.1.0 | Opening URLs in browser |
| `flutter_launcher_icons` | ^0.13.1 | App icon generation |

## 🎨 Customization

### Change App Name
Edit `lib/main.dart`:
```dart
MaterialApp(
  title: 'Your App Name',
  // ...
)
```

### Change Colors
Edit theme in `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue, // Change this color
),
```

### Add Default Links
Edit `_getDefaultLinks()` method in `LinkService` class.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Changelog

### v1.0.0
- Initial release
- Basic link management (add, edit, delete)
- URL launching and copying
- Local storage with SharedPreferences
- Responsive Material Design 3 UI
- Dark/Light theme support

## 🐛 Known Issues

- iOS build requires macOS (for .ipa generation)
- Some URL formats may need manual https:// prefix
- Web version has limited URL launching capabilities

## 🔮 Future Features

- [ ] Link categories/tags
- [ ] Search functionality
- [ ] Link preview images
- [ ] Cloud sync
- [ ] Import/Export links
- [ ] QR code generation for links
- [ ] Password protection
- [ ] Widget for home screen

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Richky Sung**
- GitHub: [@RichkySung](https://github.com/RichkySung)
- Email: richky.sung@example.com

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [Material Design](https://material.io) for the design system
- All contributors and testers

## ⭐ Support

If you like this project, please give it a star ⭐ on GitHub!

---

<div align="center">
  
Made with ❤️ by Richky Sung | Built with Flutter

[Report Bug](https://github.com/RichkySung/link4fun/issues) · [Request Feature](https://github.com/RichkySung/link4fun/issues)

</div>
