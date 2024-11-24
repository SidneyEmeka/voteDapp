import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:votedapp/balancecards.dart';
import 'package:votedapp/bnavmorph.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Sendetherpage extends StatefulWidget {
  const Sendetherpage({super.key});

  @override
  State<Sendetherpage> createState() => _SendetherpageState();
}

class _SendetherpageState extends State<Sendetherpage> {
  ///Confetti///
  bool isPopping = false;
  final confettiController = ConfettiController();

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }


  ///On-chain///
  dynamic userBalance;
  dynamic transhash;

  Future<void> sendCrypto() async {
    String remoteProcedureCallUrl =
        "http://127.0.0.1:7545"; //Ganache remote server
    String webSocketUrl =
        "ws://127.0.0.1:7545/"; // Web socket to track changes in real time

    //setting up a Webb3client which will make calls using the Http Client() to the RPC. then the web socket connector for websocket
    Web3Client myClient = Web3Client(remoteProcedureCallUrl, Client(),
        socketConnector: () =>
            IOWebSocketChannel.connect(webSocketUrl).cast<String>());

    //User Details Extraction from  private key
    String fromPrivateKey = "0xd55cd9a02afecd54975672ce0140cbfc3f7f55b6e8c63d84d96da23bd4ef8884";
    Credentials credentials = EthPrivateKey.fromHex(fromPrivateKey);
    EthereumAddress fromAddress = credentials.address;
    EthereumAddress toAddress =
        EthereumAddress.fromHex("0x5dE274CfDbd699B3d0F0Fe48E621a716fed63651");
    EtherAmount amountToSend = EtherAmount.fromInt(EtherUnit.ether, 5);

    //Send Ethereum

     myClient
         .sendTransaction(
         credentials,
         Transaction(
           from: fromAddress,
           to: toAddress,
           value: amountToSend,
         ),
         chainId: 1337)
         .then((txHash) async {
       EtherAmount newBalance =
       await myClient.getBalance(fromAddress); //Read sender balance
       setState(() {
         userBalance = newBalance
             .getValueInUnit(EtherUnit.ether); //parse and update balance to ui
         transhash = txHash; //The returned transaction hash from the transaction
         confettiController.play();
       });
     }); //always remember to add chain id


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.black,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ConfettiWidget(
                confettiController: confettiController,
                shouldLoop: false,
                blastDirectionality: BlastDirectionality.explosive,
               // numberOfParticles: 50,
                emissionFrequency: 0.5,
                gravity: 0.5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Balancecards(
                    theChild: Bnavmorph(
                      blur: 5,
                      opacity: 0.2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Flutter Dapp",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            Text(
                              "ETH Balance ${userBalance ?? ""} ",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                            const Spacer(),
                            Visibility(
                              visible: transhash != null,
                              child: Text(
                                "Transaction Hash $transhash",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    thecolor: Colors.deepPurple,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: sendCrypto,
          child: const Icon(
            Icons.send_outlined,
            color: Colors.white,
          )),
    );
  }
}
