import 'package:fl_lens/abis.dart';
import 'package:fl_lens/networking.dart';
import 'package:fl_lens/profile.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:vrouter/vrouter.dart';

import 'state.dart' as s;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Challenge {
  const Challenge(
      {required this.id, required this.name, required this.ownerId, required this.bots,});

  final String id;
  final String name;
  final BigInt ownerId;
  final List<Bot> bots;
}

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  void f(BuildContext context) async {
    final s.State state = context.watch<s.State>();
    final c = state.getLensBotContract();
    final BigInt count = await c.call<BigInt>("getChallengesCount");

    for (int i = 0; i < count.toInt(); i++) {
      final challengeAddr = await c.call<String>("challenges", [i]);
      final contract = Contract(challengeAddr, challenge, provider);
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
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 600, childAspectRatio: 2.5 / 1),
      itemCount: ownerIds.length,
      itemBuilder: (context, index) {
        final profile = Networking.getProfileFromId(
            "0x" + ownerIds[index].toRadixString(16));
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

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class Bot {
  final String name;

  Bot(this.name);
}

class _ChallengePageState extends State<ChallengePage> {
  _ChallengePageState();

  Challenge? challenge;

  void f(BuildContext context, String id) async {
    final s.State state = context.watch<s.State>();
    final contract = state.getChallengeContract(id);
    final ownerId = await contract.call<BigInt>("getOwnerprofile");
    final name = await contract.call<String>("getName");
    final botCount = await contract.call<BigInt>("getBotCount");

    for (int i = 0; i < botCount.toInt(); i++) {
      final botAddr = await contract.call<String>("bots", [i]);
      final botContract = Contract(botAddr, bot, provider);
      final botName = await botContract.call<String>("getName");
    }

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
    if (challenge != null)
    {return Column(
      children: [
        Text("Challenge", style: const TextStyle(fontSize: 20),),
        Text("Name: ${challenge?.name}"),
        ProfileFutureCard(profile: Networking.getProfileFromId("0x" + challenge!.ownerId.toRadixString(16))),

      ],
    );}
    else {return const Center(child: CircularProgressIndicator());}
  }
}
