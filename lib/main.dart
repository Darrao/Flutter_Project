import 'package:flutter/material.dart';
import 'package:memo_lens/pages/online.dart';
import 'package:memo_lens/pages/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'MemoLens', cameras: cameras),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final List<CameraDescription> cameras;

  const MyHomePage({super.key, required this.title, required this.cameras});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoggedIn = false;
  String _name = "";

  void _logIn(String name) {
    setState(() {
      _isLoggedIn = true;
      _name = name;
    });
  }

  Future<void> _logOut() async {
    final local = await SharedPreferences.getInstance();
    await local.remove('name');
    setState(() {
      _isLoggedIn = false;
      _name = "";
    });
  }

  Future<void> _checkName() async {
    final local = await SharedPreferences.getInstance();
    final name = local.getString('name') ?? "";
    setState(() {
      _name = name;
      _isLoggedIn = name.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkName();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return WelcomePage(title: widget.title, logIn: _logIn);
    }
    return OnlinePage(
      title: widget.title,
      name: _name,
      logOut: _logOut,
      cameras: widget.cameras,
    );
  }
}