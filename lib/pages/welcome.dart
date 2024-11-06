import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.title,
    required this.logIn
  });

  final String title;
  final Function(String) logIn;


  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController nameController = TextEditingController();

  Future<void> _handleLogin() async {
    String name = nameController.text;
    if(name!="") {
      final local = await SharedPreferences.getInstance();
      await local.setString('name', name);
      widget.logIn(name);
    }
  }

  @override
  void dispose(){
    nameController.dispose();
    super.dispose();
  }

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
                  style: Theme.of(context).primaryTextTheme.titleLarge),
            ],
          ),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("What's your name?"),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.pink, width:2),
                        ),
                      ),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: _handleLogin,
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.pink),
                  ),
                  child: const Text("Log in"),
                ),
              ],
            )
        )
    );
  }
}
