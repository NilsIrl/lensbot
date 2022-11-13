import 'package:fl_lens/abis.dart';
import 'package:fl_lens/networking.dart';
import 'package:fl_lens/profile.dart';
import 'package:flutter_web3/flutter_web3.dart';

import 'state.dart' as s;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  void f(BuildContext context) async {
    final s.State state = context.watch<s.State>();
    final c = state.getContract();
    final BigInt count = await c.call<BigInt>("getChallengesCount");

    for (int i = 0; i < count.toInt(); i++) {
      final challenge_addr = await c.call<String>("challenges", [i]);
      final contract = Contract(challenge_addr, challenge, provider);
      final ownerId = await contract.call<BigInt>("getOwnerprofile");
      ownerIds.add(ownerId);
      challengeAddrs.add(challenge_addr);
    }
    setState(() {});
    // context.read<s.State>().update();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    f(context);
  }

  List<BigInt> ownerIds = [];
  List<String> challengeAddrs = [];

  @override
  Widget build(BuildContext context) {
    print(ownerIds.length);

    return ListView.builder(
      itemCount: ownerIds.length,
      itemBuilder: (context, index) {
        final profile = Networking.getProfileFromId(
            "0x" + ownerIds[index].toRadixString(16));
          return ProfileFutureCard(profile: profile, );
        // return FutureBuilder(
        //     future: profile,
        //     builder: (context, future) {
        //       print(future);
        //       if (future.hasData) {
        //         final profile = future.data;
        //         if (profile == null) {
        //           return const Text("Profile not found");
        //         }
        //         return Column(
        //           children: [
        //             Text(profile.name ?? 'No name'),
        //             Text(profile.bio ?? 'No bio'),
        //             Image.network(profile.picture?.original?.url ?? ''),
        //           ],
        //         );
        //       } else {
        //         return const Center(child: CircularProgressIndicator());
        //       }
        //     });
      },
    );
  }
}
