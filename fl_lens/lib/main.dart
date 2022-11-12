import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'profile.dart';

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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
          outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: Colors.blue.prop(),
        ),
      )),
      title: 'Flutter Demo',
      home: PageOutline(
        child: VRouter(
          routes: [
            VWidget(
              path: "/profile/",
              widget: const ProfilePage(),
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
        title: const Text("Lens Bot"),
        actions: [
          OutlinedButton(
            onPressed: () {},
            child: const Text("Sign In"),
          ),
        ],
      ),
      body: Column(),
    );
  }
}
