import 'package:fl_lens/game.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'profile.dart';

const lime = Color(0xffabfe2c);

void main() {
  runApp(const MyApp());
}

extension Property<T> on T {
  MaterialStateProperty<T> prop() => MaterialStatePropertyAll(this);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: Colors.green.prop(),
            foregroundColor: Colors.white.prop(),
          ),
        ),
      ),
      title: 'Flutter Demo',
      home: PageOutline(

        child: VRouter(
          routes: [
            VWidget(
              path: "/",
              widget: Container(color: Colors.red),
            ),
            VWidget(
              path: "/profile/",
              widget: const ProfilePage(),
            ),
            VWidget(
              path: "/game/:gameid",
              widget: const GamePage(),
            ),
          ],
        ),
      ),
    );
  }
}

class PageOutline extends StatelessWidget {
  const PageOutline({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lime,
        title: const Text(
          "Lens Bot",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("Sign In"),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Column(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Welcome to Lens Bot!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Lens Bot is a bot that can play games for you!",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "To get started, sign in with your Google account.",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Sign In"),
          ),
        
        ],
      ),
    );
  }
}