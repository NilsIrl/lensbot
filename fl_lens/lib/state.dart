import 'package:fl_lens/abis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'networking.dart';

class State with ChangeNotifier {
  static const lensBotABIAddr = "0x3F359353554fe20a199BB803F87454075dEc8Cca";

  State() : super();

  String? acc;
  late Web3Provider provider;

  bool get signedIn => acc != null;
  String? jwtToken;

  void signIn() async {
    if (ethereum != null) {
      try {
        // Prompt user to connect to the provider, i.e. confirm the connection modal
        final accs = await ethereum!
            .requestAccount(); // Get all accounts in node disposal
        acc = accs[0]; // Get the first account
        provider = Web3Provider(ethereum!);

        final token = await Networking.getLoginToken(acc!);
        final signer = provider.getSigner();
        final signedToken = await signer.signMessage(token);
        final jwt = await Networking.getJWT(acc, signedToken);
        jwtToken = jwt;
        print(jwt);
      } on EthereumUserRejected {
        print('User rejected the modal');
      }
      print("logged in");
      notifyListeners();
    }
  }

  dynamic getlensBotABIContract() {
    // final provider2 = JsonRpcProvider(
    //   "https://rpc-mumbai.maticvigil.com",
    // );
    final c = Contract(
      lensBotABIAddr,
      lensBotABI,
      provider,
    );
    return c;
  }

  dynamic getChallengeContract(String addr) {
    final c = Contract(
      addr,
      challengeABI,
      provider,
    );
    return c;
  }

  dynamic getBotContract(String addr) {
    final c = Contract(
      addr,
      botABI,
      provider,
    );
    return c;
  }

  // Future<int> getChallengesCount() async {
  //   final c = getlensBotABIContract();
  //   print(c);
  //   final res = await c.call<int>("getChallengesCount");
  //   print("challenges count: $res");
  //   return res;
  // }

  // Future<List<BigInt>> getChallengeOwnerIDs() async {
  //   final c = getlensBotABIContract();
  //   print("before");
  //   final BigInt count = await c.call<BigInt>("getChallengesCount");
  //   print(count);
  //   print("after");
  //   var addrs = [];
  //   for (int i = 0; i < count.toInt(); i++) {
  //     final challenge_addr = await c.call("challenges", [i]);
  //     final contract = Contract(challenge_addr, challengeABI, provider);
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
