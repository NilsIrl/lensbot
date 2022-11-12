import 'package:fl_lens/abis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

class State with ChangeNotifier {
  static const lensbotAddr = "0xEfB7C195AAcB0083e2a8fe60f8C5104dC5fC6BB2";

  State() : super();

  LoginState? loginState;
  String? acc;
  late Web3Provider provider;

  void signIn() async {
    if (ethereum != null) {
      try {
        // Prompt user to connect to the provider, i.e. confirm the connection modal
        final accs = await ethereum!
            .requestAccount(); // Get all accounts in node disposal
        acc = accs[0]; // Get the first account
        provider = Web3Provider(ethereum!);
      } on EthereumUserRejected {
        print('User rejected the modal');
      }
      notifyListeners();
    }
  }

  dynamic getContract() {
    final c = Contract(
      lensbotAddr,
      lensbot,
      provider,
    );
    return c;
  }

  Future<int> getChallengesCount() async {
    final c = getContract();
    final res = await c.call("getChallengesCount");
    return res;
  }

  Future<dynamic> getChallenge(int id) async {
    final c = getContract();
    final res = await c.call("challenges", [id]);
    return res;
  }

  Future<List<String>> getChallengeOwnderIDs() async {
    final c = getContract();
    final count = await getChallengesCount();
    var addrs = [];
    for (int i = 0; i < count; i++) {
      final challenge_addr = await getChallenge(i);
      final contract = Contract(challenge_addr, challenge, provider);
      final owner_id = await contract.call("getOwnerProfile");
      addrs.add(owner_id);
    }
    return Future.value(addrs.cast<String>());
  }
}

class LoginState {
  LoginState({required this.username});

  String username;
}
