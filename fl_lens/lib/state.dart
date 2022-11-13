import 'package:fl_lens/abis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

class State with ChangeNotifier {
  static const lensbotAddr = "0x5bf4dfe318901DCacFD2986BA2c8a58389AaFc86";

  State() : super();

  String? acc;
  late Web3Provider provider;

  bool get signedIn => acc != null;

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
      print("logged in");
      notifyListeners();
    }
  }

  dynamic getLensBotContract() {
    // final provider2 = JsonRpcProvider(
    //   "https://rpc-mumbai.maticvigil.com",
    // );
    final c = Contract(
      lensbotAddr,
      lensbot,
      provider,
    );
    return c;
  }

  dynamic getChallengeContract(String addr) {
    final c = Contract(
      addr,
      challenge,
      provider,
    );
    return c;
  }

  // Future<int> getChallengesCount() async {
  //   final c = getLensBotContract();
  //   print(c);
  //   final res = await c.call<int>("getChallengesCount");
  //   print("challenges count: $res");
  //   return res;
  // }

  // Future<List<BigInt>> getChallengeOwnerIDs() async {
  //   final c = getLensBotContract();
  //   print("before");
  //   final BigInt count = await c.call<BigInt>("getChallengesCount");
  //   print(count);
  //   print("after");
  //   var addrs = [];
  //   for (int i = 0; i < count.toInt(); i++) {
  //     final challenge_addr = await c.call("challenges", [i]);
  //     final contract = Contract(challenge_addr, challenge, provider);
  //     final ownerId = await contract.call<BigInt>("getOwnerprofile");
  //     addrs.add(ownerId);
  //   }
  //   print("returning $addrs");
  //   return Future.value(addrs.cast<String>());
  // }

  void update() {
    notifyListeners();
  }
}

class LoginState {
  LoginState({required this.username});

  String username;
}
