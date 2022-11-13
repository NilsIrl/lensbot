import 'package:fl_lens/bot.dart';
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
                widget: const ChallengesPage(),
              ),
              VWidget(
                path: "/challenge/:id",
                widget: const ChallengePage(),
              ),
              VWidget(
                path: "/challenge/:id/bot/:botId",
                widget: const BotPage(),
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
                  VRouter.of(context).to("/");
                },
                child: const Text("Home"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  VRouter.of(context).to("/challenges/");
                },
                child: const Text("Challenges"),
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
    return Container(
        padding: const EdgeInsets.all(20),      
        child: const SingleChildScrollView(
      child: Text("""
In The Prisoner's Dilemma, two agents are given a choice: cooperate with their partner for mutual reward, or defect for individual reward.

The dilemma faced by the agents is that, regardless of what their opponent does, they are always better off defecting than cooperating. But the combined outcome when both defect is worse than if they cooperate.

For a purely rational agent with no prior knowledge, always defecting is the correct choice.

A variation on this is an iterated prisoner's dilemma, multiple rounds are played, and the previous responses of each agent are given as an input to the players. This vastly widens the space of feasible strategies, and can lead to some diverse and unexpected strategies performing best.

We wanted to build a platform for running these kinds of challenges.

Players can create strategies which contain logic to compete in challenges. Strategies are smart contracts and exist on-chain. Each turn, they are given the history of their opponent's moves, as well as their opponent's address. This allows strategies to make decisions based on their opponent's previous choices. Passing the address of their opponent allows the strategy to call them directly, and probe it with previously unseen input.

Challenges are run on chain through Challenges contracts. Strategies can be registered for challenges, where they join the pool of competing strategies, and are scored and ranked by the Challenge contract."""),
    ),);
  }
}
