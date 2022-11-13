import 'package:fl_lens/challenge.dart';
import 'package:fl_lens/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';
import 'profile.dart';
import 'state.dart' as s;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => s.State()),
      ],
      child: VRouter(
        routes: [
          VNester(
            path: null,
            widgetBuilder: (child) => PageOutline(child: child),
            nestedRoutes: [
              VWidget(path: "/", widget: const HomePage()),
              VWidget(
                path: "/profile/:id",
                widget: const ProfilePage(),
              ),
              VWidget(
                path: "/game/:gameid",
                widget: const GamePage(),
              ),
              VWidget(
                path: "/challenges/",
                widget: const ChallengePage(),
              ),
            ],
          ),
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
              const SiginInButton(),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  VRouter.of(context).to("/challenges/");
                },
                child: const Text("Challenges"),
              ),
              const SizedBox(width: 10),
              // ElevatedButton(
              //   onPressed: () {
              //     context.read<s.State>().signIn();
              //   },
              //   child: const Text("Sign In"),
              // ),
              // const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: child,
    );
  }
}

class SiginInButton extends StatelessWidget {
  const SiginInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<s.State>();
    if (state.acc != null) {
      return const SizedBox.shrink();
    } else {
      return ElevatedButton(
        onPressed: () {
          context.read<s.State>().signIn();
        },
        child: const Text("Sign In"),
      );
    }
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
            child: const Text(
              "Sign In",
            ),
          ),
        ],
      ),
    );
  }
}
