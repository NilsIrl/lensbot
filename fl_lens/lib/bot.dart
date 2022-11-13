import 'package:fl_lens/challenge.dart';
import 'package:fl_lens/networking.dart';
import 'package:fl_lens/profile.dart';
import 'package:vrouter/vrouter.dart';
import 'state.dart' as s;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BotPage extends StatefulWidget {
  const BotPage({super.key});

  @override
  State<BotPage> createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  _BotPageState();

  Challenge? challenge;
  Bot? bot;
  List<List<List<bool>>>? playsArray;

  void f(BuildContext context, String id, String botId) async {
    final s.State state = context.watch<s.State>();
    final contract = state.getChallengeContract(id);
    final ownerId = await contract.call<BigInt>("getOwnerprofile");
    final name = await contract.call<String>("getName");
    final botCount = await contract.call<BigInt>("getBotCount");
    final roundLength = await contract.call<BigInt>("getRoundLength");
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
    bot = bots.firstWhere((element) => element.addr == botId);
    final plays = <List<List<bool>>>[];

    for (int i = 0; i < bots.length; i++) {
      final boti = bots[i];

      final playsForBoti = <List<bool>>[];

      for (int j = 0; j < bots.length; j++) {
        final botj = bots[j];
        if (i == j) {
          continue;
        }

        final playsForBotivsBotj = <bool>[];

        for (int turn = 0; turn < roundLength.toInt(); turn++) {
          final play =
              await contract.call<bool>("plays", [boti.addr, botj.addr, turn]);
          final play2 =
              await contract.call<bool>("plays", [botj.addr, boti.addr, turn]);
          playsForBotivsBotj.add(play);
          playsForBotivsBotj.add(play2);
        }

        playsForBoti.add(playsForBotivsBotj);
      }

      plays.add(playsForBoti);
    }
    playsArray = plays;

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    final id = VRouter.of(context).pathParameters["id"];
    final botId = VRouter.of(context).pathParameters["botId"];
    f(context, id!, botId!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (challenge != null) {
      return Center(
        child: Column(
          children: [
            const Text(
              "Bot",
              style: TextStyle(fontSize: 20),
            ),
            Text("Name: ${challenge?.name}"),
            SizedBox(
                height: 300,
                child: ProfileFutureCard(
                    profile: Networking.getProfileFromId(
                        "0x${challenge!.ownerId.toRadixString(16)}"))),
            Expanded(
              child:
                  ArrayViewer(challenge: challenge!, playsArray: playsArray!),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class ArrayViewer extends StatefulWidget {
  const ArrayViewer(
      {super.key, required this.challenge, required this.playsArray});

  final Challenge challenge;
  // Game -> round -> turn
  final List<List<List<bool>>> playsArray;

  @override
  State<ArrayViewer> createState() => _ArrayViewerState();
}

class _ArrayViewerState extends State<ArrayViewer> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    final bots = widget.challenge.bots;

    return Column(
      children: [
        Text("Bot: ${widget.challenge.bots[idx].name}"),
        Expanded(
          child: Center(
            child: ListView.builder(
              itemCount: widget.challenge.bots.length,
              itemBuilder: (context, i) {
                final game = widget.playsArray[idx];
                final bot = widget.challenge.bots[i > idx ? i - 1 : i];
                return Column(
                  children: game
                      .map((e) => Expanded(
                        child: Row(
                              children: e
                                  .map(
                                    (e) => SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              color: e ? Colors.red : Colors.green,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: e ? Colors.red : Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                      ))
                      .toList(),
                );
              },
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         setState(() {
        //           idx = (idx - 1) % widget.challenge.bots.length;
        //         });
        //       },
        //       child: const Text("Prev"),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         setState(() {
        //           idx = (idx + 1) % widget.challenge.bots.length;
        //         });
        //       },
        //       child: const Text("Next"),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
