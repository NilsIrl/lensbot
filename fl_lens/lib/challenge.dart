import 'state.dart' as s;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<s.State>();

    final challenges = state.getChallengeOwnderIDs();
    

    return const ListView.builder(itemBuilder: );
  }
}