import 'package:fl_lens/abis.dart';
import 'package:fl_lens/challenge.dart';
import 'package:fl_lens/networking.dart';
import 'package:fl_lens/profile.dart';
import 'package:flutter_web3/flutter_web3.dart';
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

  void f(BuildContext context, String id, String botId) async {
    final s.State state = context.watch<s.State>();
    final contract = state.getBotContract(id);
    final ownerId = await contract.call<BigInt>("getOwnerprofile");
    final name = await contract.call<String>("getName");
    final botCount = await contract.call<BigInt>("getBotCount");
    var bots = <Bot>[];
    for (int i = 0; i < botCount.toInt(); i++) {
      final botAddr = await contract.call<String>("getLeaderboardAt", [i]);
      final botContract = Contract(botAddr, botABI, provider);
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
    );
    bot = bots.firstWhere((element) => element.addr == botId);
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
    if (challenge != null)
    {return Column(
      children: [
        const Text("Bot", style: const TextStyle(fontSize: 20),),
        Text("Name: ${challenge?.name}"),
        ProfileFutureCard(profile: Networking.getProfileFromId("0x" + challenge!.ownerId.toRadixString(16))),
        // Expanded(child: ListView.builder(itemBuilder: (context, index) {
        //   final bot = challenge!.bots[index];
        //   return Text("${bot.name} ${bot.points}");
        // }, itemCount: challenge!.bots.length,))
        Text("Bot name: ${bot?.name}"),
      ],
    );}
    else {return const Center(child: CircularProgressIndicator());}
  }
}
