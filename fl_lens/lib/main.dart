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
    return VRouter(
      routes: [
        VWidget(
          path: '/',
          widget: const HomePage(),
          stackedRoutes: [
            VWidget(
              path: '/profile/:id',
              widget: const ProfilePage(),
            ),
            VWidget(
              path: '/game',
              widget: const GamePage(),
            ),
          ],
        ),
        // VNester(
        //   path: null,
        //   widgetBuilder: (child) => PageOutline(child: child),
        //   nestedRoutes: [
        //     VWidget(path: "/home/", widget: const HomePage()),
        //     VWidget(
        //       path: "/profile/:id",
        //       widget: const ProfilePage(),
        //     ),
        //     VWidget(
        //       path: "/game/:gameid",
        //       widget: const GamePage(),
        //     ),
        //   ],
        // ),
      ],
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
      body: child,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("hi");
    return PageOutline(
      child: Center(
        child: Column(
          children: [
            const Text(
              "Welcome to Lens Bot!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Lens Bot is a bot that can play games for you!",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              "To get started, sign in with your Google account.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.vRouter.to("/profile/0x5303");
              },
              child: const Text("Sign In",),
            ),
          ],
        ),
      ),
    );
  }
}
