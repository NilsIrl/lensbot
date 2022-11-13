import 'state.dart' as s;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<s.State>();

    final challenges = state.getChallengeOwnderIDs();

    return const SizedBox.shrink();
  }
}

class Challenge {
  final int botCount;
  final Map<String, int> botScores;
  final String owner;

  const Challenge({
    required this.botCount,
    required this.botScores,
    required this.owner,
  });

  List<LeaderboardEntry> getLeaderboard() {
    List<LeaderboardEntry> leaderboard = [];
    botScores.forEach(
        (k, v) => leaderboard.add(LeaderboardEntry(addr: k, score: v)));
    leaderboard.sort((a, b) => b.score.compareTo(a.score));
    return leaderboard;
  }
}

class LeaderboardEntry {
  final String addr;
  final int score;

  const LeaderboardEntry({
    required this.addr,
    required this.score,
  });
}
