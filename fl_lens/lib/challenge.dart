import 'package:fl_lens/abis.dart';
import 'package:fl_lens/main.dart';
import 'package:fl_lens/networking.dart';
import 'package:fl_lens/profile.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:vrouter/vrouter.dart';

import 'state.dart' as s;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Challenge {
  const Challenge({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.bots,
    required this.roundLength,
  });

  final String id;
  final String name;
  final BigInt ownerId;
  final List<Bot> bots;
  final BigInt roundLength;
}

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  void f(BuildContext context) async {
    final s.State state = context.watch<s.State>();
    final c = state.getlensBotABIContract();
    final BigInt count = await c.call<BigInt>("getChallengesCount");

    for (int i = 0; i < count.toInt(); i++) {
      final challengeAddr = await c.call<String>("challenges", [i]);
      final contract = Contract(challengeAddr, challengeABI, provider);
      final ownerId = await contract.call<BigInt>("getOwnerprofile");
      final name = await contract.call<String>("getName");
      ownerIds.add(ownerId);
      challengeAddrs.add(challengeAddr);
      names.add(name);
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    f(context);
  }

  List<BigInt> ownerIds = [];
  List<String> challengeAddrs = [];
  List<String> names = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 900, childAspectRatio: 2.8 / 1),
      itemCount: ownerIds.length,
      itemBuilder: (context, index) {
        final profile = Networking.getProfileFromId(
            "0x${ownerIds[index].toRadixString(16)}");
        return ProfileFutureCard(
          profile: profile,
          addr: challengeAddrs[index],
          name: names[index],
          onClick: () => VRouter.of(context).to(
            "/challenge/${challengeAddrs[index]}",
          ),
        );
      },
    );
  }
}

class Bot {
  final String name;
  final String addr;
  final BigInt points;

  Bot({required this.name, required this.addr, required this.points});
}

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  _ChallengePageState();

  Challenge? challenge;

  void f(BuildContext context, String id) async {
    final s.State state = context.watch<s.State>();
    final contract = state.getChallengeContract(id);
    final ownerId = await contract.call<BigInt>("getOwnerprofile");
    final name = await contract.call<String>("getName");
    final BigInt roundLength = await contract.call<BigInt>("getRoundLength");
    final botCount = await contract.call<BigInt>("getBotCount");
    var bots = <Bot>[];
    for (int i = 0; i < botCount.toInt(); i++) {
      final botAddr = await contract.call<String>("getLeaderboardAt", [i]);
      final botContract = state.getBotContract(botAddr);
      final botName = await botContract.call<String>("getName");
      final points = await contract.call<BigInt>("getPoints", [botAddr]);
      final bot = Bot(name: botName, addr: botAddr, points: points);
      bots.add(bot);
    }
    bots.sort((a, b) => a.points.compareTo(b.points));
    challenge = Challenge(
        id: id,
        name: name,
        ownerId: ownerId,
        bots: bots,
        roundLength: roundLength);

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    final id = VRouter.of(context).pathParameters["id"];
    f(context, id!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (challenge != null) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300, childAspectRatio: 2.5 / 1),
        itemBuilder: (context, index) {
          final bot = challenge!.bots[index];
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: lime,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text(
                        bot.name,
                      ),
                      const Spacer(),
                      Text(
                        "${bot.points}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () async {
                          await Share.share("Check out this bot! ${bot.addr}");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              VRouter.of(context).to(
                "/challenge/${VRouter.of(context).pathParameters["id"]}/bot/${bot.addr}",
              );
            },
          );
        },
        itemCount: challenge!.bots.length,
      );
      // return Column(
      //   children: [
      //     Text(
      //       "Challenge: ${challenge!.name}",
      //       style: const TextStyle(fontSize: 20),
      //     ),
      //     ProfileFutureCard(
      //         profile: Networking.getProfileFromId(
      //       "0x${challenge!.ownerId.toRadixString(
      //         16,
      //       )}",
      //     )),
      //     Expanded(
      //       child: GridView.builder(
      //         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //             maxCrossAxisExtent: 300, childAspectRatio: 2.5 / 1),
      //         itemBuilder: (context, index) {
      //           final bot = challenge!.bots[index];
      //           return InkWell(
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Card(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(20.0),
      //                 ),
      //                 color: lime,
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(12.0),
      //                   child: Row(
      //                     children: [
      //                       Text(
      //                         bot.name,
      //                       ),
      //                       const Spacer(),
      //                       Text(
      //                         "${bot.points}",
      //                         style: const TextStyle(
      //                           color: Colors.green,
      //                           fontSize: 18,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             onTap: () {
      //               print("tapppppp");
      //               VRouter.of(context).to(
      //                 "/challenge/${VRouter.of(context).pathParameters["id"]}/bot/${bot.addr}",
      //               );
      //             },
      //           );
      //         },
      //         itemCount: challenge!.bots.length,
      //       ),
      //     ),
      //   ],
      // );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
