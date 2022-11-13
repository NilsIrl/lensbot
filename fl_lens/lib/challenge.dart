import 'package:fl_lens/abis.dart';
import 'package:fl_lens/networking.dart';
import 'package:fl_lens/profile.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:vrouter/vrouter.dart';

import 'state.dart' as s;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            "/challenge/${challengeAddrs[index]}",          ),
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

class _ChallengePageState extends State<ChallengePage> {
  _ChallengePageState();

  late String id; 

  void f(BuildContext context) async {
    final s.State state = context.watch<s.State>();
    final c = state.getChallengeContract(id);
    final name = await c.call<String>("getName");
    // final desc = await c.call<String>("getDescription");
    // final BigInt count = await c.call<BigInt>("getChallengesCount");

    // for (int i = 0; i < count.toInt(); i++) {
    //   final challengeAddr = await c.call<String>("challenges", [i]);
    //   final contract = Contract(challengeAddr, challenge, provider);
    //   final ownerId = await contract.call<BigInt>("getOwnerprofile");
    //   final name = await contract.call<String>("getName");
    //   ownerIds.add(ownerId);
    //   challengeAddrs.add(challengeAddr);
    //   names.add(name);
    // }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    f(context);
    final id = VRouter.of(context).pathParameters["id"];
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    // final contract = Contract() ;

    return const Placeholder();
  }
}