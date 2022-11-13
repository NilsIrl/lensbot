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
  int? rank;
  String? ownerId;

  void f(BuildContext context, String id, String botId) async {
    final s.State state = context.watch<s.State>();
    final contract = state.getChallengeContract(id);
    final ownerId = await contract.call<BigInt>("getOwnerprofile");
    final name = await contract.call<String>("getName");
    final botCount = await contract.call<BigInt>("getBotCount");
    final BigInt roundLength = await contract.call<BigInt>("getRoundLength");
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
    rank = bots.indexOf(bot!);
    final games = <List<List<bool>>>[];
    for (int i = 0; i < bots.length; i++) {
      if (i == rank) continue;
      final game = <List<bool>>[];
      for (int j = 0; j < roundLength.toInt(); j++) {
        final round = <bool>[];
        final p1 = await contract.call<bool>("plays", [botId, bots[i].addr, j])
            as bool;
        final p2 = await contract.call<bool>("plays", [bots[i].addr, botId, j])
            as bool;
        round.addAll([p1, p2]);
        game.add(round);
      }
      games.add(game);
    }
    playsArray = games;
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
              "\nBot",
              style: TextStyle(fontSize: 20),
            ),
            Text("Name: ${challenge?.name}\n"),
            Center(
              child: SizedBox(
                height: 300,
                width: 700,
                child: ProfileFutureCard(
                  profile: Networking.getProfileFromId(
                    "0x${challenge!.ownerId.toRadixString(16)}",
                  ),
                  addr: "0x${challenge!.ownerId.toRadixString(16)}",
                ),
              ),
            ),
            Expanded(
              child: ArrayViewer(
                challenge: challenge!,
                playsArray: playsArray!,
                rank: rank!,
              ),
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
  const ArrayViewer({
    super.key,
    required this.challenge,
    required this.playsArray,
    required this.rank,
  });

  final Challenge challenge;
  final int rank;
  // Game -> round -> turn
  final List<List<List<bool>>> playsArray;

  @override
  State<ArrayViewer> createState() => _ArrayViewerState();
}

class _ArrayViewerState extends State<ArrayViewer> {
  @override
  Widget build(BuildContext context) {
    final bots = widget.challenge.bots;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final game = widget.playsArray[index];
          final bot = bots[index > widget.rank ? index - 1 : index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(bot.name),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: game
                      .map(
                        (e) => Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: !e[0] ? Colors.green : Colors.red,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: !e[1] ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
        itemCount: widget.playsArray.length,
      ),
    );
  }
}
