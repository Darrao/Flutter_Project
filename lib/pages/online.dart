import 'package:flutter/material.dart';
import 'gallery.dart';
import 'archive.dart';  // Import de ArchivePage
import 'package:camera/camera.dart';

class OnlinePage extends StatefulWidget {
  const OnlinePage({
    super.key,
    required this.title,
    required this.name,
    required this.logOut,
    required this.cameras,
  });

  final String title;
  final String name;
  final VoidCallback logOut;
  final List<CameraDescription> cameras;

  @override
  State<OnlinePage> createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {
  int _selectedIndex = 0;

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages = [
    GalleryPage(name: widget.name, cameras: widget.cameras),
    const ArchivePage() // Utilisation de ArchivePage
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).primaryTextTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: widget.logOut,
              tooltip: 'Log Out',
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            backgroundColor: Theme.of(context).hoverColor,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.photo_album),
                label: Text("Gallery"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.delete),
                label: Text("Archive"),
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectIndex,
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_album), label: "Gallery"),
          BottomNavigationBarItem(
              icon: Icon(Icons.delete), label: "Archive"),
        ],
        currentIndex: _selectedIndex,
        onTap: _selectIndex,
        selectedItemColor: Colors.pink,
      ),
    );
  }
}