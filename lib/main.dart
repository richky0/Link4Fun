import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const Click4FunApp());
}

// Model untuk Link
class Link {
  final String id;
  final String title;
  final String url;
  final String icon;
  final int colorValue;

  Link({
    required this.id,
    required this.title,
    required this.url,
    required this.icon,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'url': url,
    'icon': icon,
    'colorValue': colorValue,
  };

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    id: json['id'],
    title: json['title'],
    url: json['url'],
    icon: json['icon'],
    colorValue: json['colorValue'],
  );
}

// Helper untuk membuat warna
int getColorValue(int r, int g, int b) {
  return (0xFF << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
}

// Service untuk menyimpan link
class LinkService {
  static const String _key = 'click4fun_links';

  Future<List<Link>> getLinks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return _getDefaultLinks();

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Link.fromJson(json)).toList();
    } catch (e) {
      return _getDefaultLinks();
    }
  }

  Future<void> saveLinks(List<Link> links) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = links.map((link) => link.toJson()).toList();
    await prefs.setString(_key, json.encode(jsonList));
  }

  List<Link> _getDefaultLinks() {
    return [
      Link(
        id: '1',
        title: 'Google Search',
        url: 'https://google.com',
        icon: '🌐',
        colorValue: getColorValue(66, 133, 244),
      ),
      Link(
        id: '2',
        title: 'YouTube Videos',
        url: 'https://youtube.com',
        icon: '📺',
        colorValue: getColorValue(255, 0, 0),
      ),
      Link(
        id: '3',
        title: 'GitHub Repository',
        url: 'https://github.com',
        icon: '💻',
        colorValue: getColorValue(36, 41, 46),
      ),
      Link(
        id: '4',
        title: 'Twitter Social',
        url: 'https://twitter.com',
        icon: '🐦',
        colorValue: getColorValue(29, 161, 242),
      ),
      Link(
        id: '5',
        title: 'Instagram Photos',
        url: 'https://instagram.com',
        icon: '📸',
        colorValue: getColorValue(225, 48, 108),
      ),
      Link(
        id: '6',
        title: 'Facebook Social Network',
        url: 'https://facebook.com',
        icon: '👥',
        colorValue: getColorValue(24, 119, 242),
      ),
      Link(
        id: '7',
        title: 'LinkedIn Professional',
        url: 'https://linkedin.com',
        icon: '💼',
        colorValue: getColorValue(10, 102, 194),
      ),
      Link(
        id: '8',
        title: 'Netflix Movies',
        url: 'https://netflix.com',
        icon: '🎬',
        colorValue: getColorValue(229, 9, 20),
      ),
    ];
  }
}

// Main App dengan animasi page transition
class Click4FunApp extends StatelessWidget {
  const Click4FunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Link4Fun',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final LinkService _linkService = LinkService();
  late Future<List<Link>> _linksFuture;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  List<Link> _allLinks = [];
  List<Link> _filteredLinks = [];
  bool _isSearching = false;
  String _currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLinks();

    // Setup animasi
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start animasi saat init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadLinks() async {
    setState(() {
      _linksFuture = _linkService.getLinks();
    });

    final links = await _linkService.getLinks();
    setState(() {
      _allLinks = links;
      _filteredLinks = links;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _currentSearchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        _filteredLinks = _allLinks;
      });
    } else {
      final filtered = _allLinks.where((link) {
        return link.title.toLowerCase().contains(query.toLowerCase()) ||
            link.url.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        _filteredLinks = filtered;
      });
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _currentSearchQuery = '';
      _filteredLinks = _allLinks;
    });
    _searchFocusNode.unfocus();
  }

  // Fungsi untuk membuat text dengan highlight
  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
      );
    }

    final matches = <TextSpan>[];
    int start = 0;
    int end;

    while ((end = lowerText.indexOf(lowerQuery, start)) != -1) {
      // Tambahkan teks sebelum match
      if (end > start) {
        matches.add(TextSpan(
          text: text.substring(start, end),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Colors.black87,
          ),
        ));
      }

      // Tambahkan teks yang match dengan highlight
      matches.add(TextSpan(
        text: text.substring(end, end + query.length),
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: Colors.blue,
          backgroundColor: Color(0xFFE3F2FD),
        ),
      ));

      start = end + query.length;
    }

    // Tambahkan sisa teks setelah match terakhir
    if (start < text.length) {
      matches.add(TextSpan(
        text: text.substring(start),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
          color: Colors.black87,
        ),
      ));
    }

    return RichText(
      text: TextSpan(
        children: matches,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<void> _refreshLinks() async {
    await _loadLinks();
    _showSuccess('Links refreshed');
  }

  Future<void> _addLink() async {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || url.isEmpty) {
      _showError('Please fill in both title and URL');
      return;
    }

    final links = await _linkService.getLinks();
    final newLink = Link(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      url: url.startsWith('http') ? url : 'https://$url',
      icon: '🔗',
      colorValue: getColorValue(33, 150, 243),
    );

    links.add(newLink);
    await _linkService.saveLinks(links);

    _titleController.clear();
    _urlController.clear();

    if (!mounted) return;

    await _loadLinks();
    _showSuccess('Link added successfully!');
  }

  Future<void> _deleteLink(Link link) async {
    // Tampilkan konfirmasi delete
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Link'),
        content: Text('Are you sure you want to delete "${link.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final links = await _linkService.getLinks();
    links.removeWhere((l) => l.id == link.id);
    await _linkService.saveLinks(links);

    if (!mounted) return;

    await _loadLinks();
    _showSuccess('Link deleted successfully', isError: true);
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      _showCopySuccess(text);
    }
  }

  void _showCopySuccess(String copiedText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Link Copied!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    copiedText,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      String finalUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        finalUrl = 'https://$url';
      }

      final uri = Uri.parse(finalUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showError('No app found to open this URL');
      }
    } catch (e) {
      _showError('Failed to open: $url');
    }
  }

  void _showSuccess(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // FUNGSI QR CODE YANG DIPERBAIKI
  void _showQRCodeDialog(Link link) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.qr_code, color: link.color, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          'QR Code',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: link.color,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // QR Code Container
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: link.color.withOpacity(0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: link.url,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: link.color,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Link Info
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: link.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        link.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: link.color,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SelectableText(
                        link.url,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _copyToClipboard(link.url);
                        },
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy URL'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _launchUrl(link.url);
                        },
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('Open Link'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: link.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddLinkDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter link title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'example.com',
                border: OutlineInputBorder(),
                prefixText: 'https://',
              ),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addLink();
            },
            child: const Text('Add Link'),
          ),
        ],
      ),
    );
  }

  void _showLinkOptions(Link link) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: link.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.qr_code, color: link.color),
                ),
                title: Text(
                  'Generate QR Code',
                  style: TextStyle(fontWeight: FontWeight.bold, color: link.color),
                ),
                subtitle: const Text('Create QR code for this link'),
                onTap: () {
                  Navigator.pop(context);
                  _showQRCodeDialog(link);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.open_in_new, color: Colors.blue),
                ),
                title: const Text(
                  'Open Link',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl(link.url);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.copy, color: Colors.green),
                ),
                title: const Text(
                  'Copy URL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _copyToClipboard(link.url);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit, color: Colors.orange),
                ),
                title: const Text(
                  'Edit Link',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _editLink(link);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text(
                  'Delete Link',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteLink(link);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editLink(Link link) async {
    _titleController.text = link.title;
    _urlController.text = link.url.replaceFirst('https://', '').replaceFirst('http://', '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                border: OutlineInputBorder(),
                prefixText: 'https://',
              ),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final links = await _linkService.getLinks();
              final index = links.indexWhere((l) => l.id == link.id);

              if (index != -1) {
                final title = _titleController.text.trim();
                final url = _urlController.text.trim();

                if (title.isEmpty || url.isEmpty) {
                  _showError('Please fill in both title and URL');
                  return;
                }

                links[index] = Link(
                  id: link.id,
                  title: title,
                  url: url.startsWith('http') ? url : 'https://$url',
                  icon: link.icon,
                  colorValue: link.colorValue,
                );

                await _linkService.saveLinks(links);
                await _loadLinks();
                _showSuccess('Link updated successfully!');
              }

              _titleController.clear();
              _urlController.clear();
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkCard(Link link, int index) {
    return GestureDetector(
      onLongPress: () => _showLinkOptions(link),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200 + (index * 50)),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 12),
        transform: Matrix4.translationValues(0, _slideAnimation.value, 0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _launchUrl(link.url),
                  splashColor: link.color.withOpacity(0.2),
                  highlightColor: link.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            link.color.withOpacity(0.3),
                            link.color.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: link.color.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            link.icon,
                            key: ValueKey(link.icon),
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                    ),
                    title: _buildHighlightedText(link.title, _currentSearchQuery),
                    subtitle: Text(
                      link.url,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: link.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.qr_code,
                              size: 20,
                              color: link.color,
                            ),
                          ),
                          onPressed: () => _showQRCodeDialog(link),
                          tooltip: 'Generate QR Code',
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.more_vert,
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                          onPressed: () => _showLinkOptions(link),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // PERBAIKAN: Semua fungsi yang mengembalikan AppBar
  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.blue),
        onPressed: _stopSearch,
      ),
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, color: Colors.grey, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search links by title or URL...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                cursorColor: Colors.blue,
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                onPressed: () {
                  _searchController.clear();
                },
                padding: const EdgeInsets.all(8),
              ),
          ],
        ),
      ),
      actions: [
        if (_currentSearchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_filteredLinks.length} found',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      title: const Text(
        'Link4Fun',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search, size: 22),
          ),
          onPressed: _startSearch,
          tooltip: 'Search',
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add, size: 22),
          ),
          onPressed: _showAddLinkDialog,
          tooltip: 'Add New Link',
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.refresh, size: 22),
          ),
          onPressed: _refreshLinks,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar() : _buildNormalAppBar(),
      body: FutureBuilder<List<Link>>(
        future: _linksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1.0,
                    child: Text(
                      'Loading your links...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading links',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshLinks,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final linksToShow = _isSearching ? _filteredLinks : _allLinks;

          if (linksToShow.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 120,
                    height: 120,
                    child: Icon(
                      Icons.add_link,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1.0,
                    child: Text(
                      _isSearching ? 'No search results' : 'Welcome to Link4Fun',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _isSearching
                          ? 'No links found for "$_currentSearchQuery"'
                          : 'Add your favorite links and access them with one tap',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _showAddLinkDialog,
                    icon: const Icon(Icons.add),
                    label: Text(_isSearching ? 'Add New Link' : 'Add Your First Link'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Column(
              key: ValueKey(_isSearching),
              children: [
                if (!_isSearching)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Text(
                          'Your Links (${linksToShow.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: linksToShow.length,
                    itemBuilder: (context, index) {
                      return _buildLinkCard(linksToShow[index], index);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}