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
  final confettiController = ConfettiController();

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  ///Progress Indicator
  bool isLoading = false;


  ///On-chain///
  dynamic userBalance;
  dynamic transhash;

  Future<void> sendCrypto(String recAddress, dynamic amount) async {
    setState(() {
      isLoading=true;
    });
    String remoteProcedureCallUrl =
        "http://127.0.0.1:7545"; //Ganache remote server
    String webSocketUrl =
        "ws://127.0.0.1:7545/"; // Web socket to track changes in real time

    //setting up a Webb3client which will make calls using the Http Client() to the RPC. then the web socket connector for websocket
    Web3Client myClient = Web3Client(remoteProcedureCallUrl, Client(),
        socketConnector: () =>
            IOWebSocketChannel.connect(webSocketUrl).cast<String>());

    //User Details Extraction from  private key
    String fromPrivateKey = "0x01c7f267b2c43570aca55f45b33434c32939074c56cf885f80c22eeeeb90d341";
    Credentials credentials = EthPrivateKey.fromHex(fromPrivateKey);
    EthereumAddress fromAddress = credentials.address;
    EthereumAddress toAddress = EthereumAddress.fromHex(recAddress);
    EtherAmount amountToSend = EtherAmount.fromInt(EtherUnit.ether, amount);


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
         transhash = txHash;
         isLoading=false;//The returned transaction hash from the transaction
         confettiController.play();
       });
     }); //always remember to add chain id


  }

  TextEditingController receiverAddress = TextEditingController();
  TextEditingController amountToSend = TextEditingController();



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
                            Visibility(visible: isLoading,child: LinearProgressIndicator(color: Colors.white,borderRadius: BorderRadius.circular(10),backgroundColor: Colors.deepPurple,)),
                            const Text(
                              "Flutter Dapp",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            Text(
                              "Balance ${userBalance ?? "-"} Eth",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                            const Spacer(flex: 2,),
                            //Address
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "To",
                                    style:
                                    TextStyle(fontSize: 10, color: Colors.white),
                                  ),
                                  const SizedBox(height: 5,),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 11,color: Colors.black),
                                    controller: receiverAddress,
                                    cursorColor: Colors.deepPurple,
                                    cursorHeight: 15,
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: "ETH Address",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(color: Colors.white)
                                      ),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(color:Colors.white)
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(color: Colors.white)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(color: Colors.black12,width: 1)
                                      ),
                                    ),

                                  ),
                                ],
                              ),
                            ),
                            const Spacer(flex: 1,),
                            //Amount
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Sending",
                                    style:
                                    TextStyle(fontSize: 10, color: Colors.white),
                                  ),
                                  const SizedBox(height: 5,),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 11,color: Colors.black),
                                    controller: amountToSend,
                                    cursorColor: Colors.deepPurple,
                                    cursorHeight: 15,
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: "Amount",
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(color: Colors.white)
                                      ),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(color:Colors.white)
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(color: Colors.white)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          borderSide: const BorderSide(color: Colors.black12,width: 1)
                                      ),
                                    ),

                                  ),
                                ],
                              ),
                            ),
                            const Spacer(flex: 2,),
                            Visibility(
                              visible: transhash != null,
                              child: Text(
                                "Trx Hash: $transhash",
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
          onPressed: (){
            sendCrypto(receiverAddress.text.trim(),num.parse(amountToSend.text.trim()));
          },
          child: const Icon(
            Icons.send_outlined,
            color: Colors.white,
          )),
    );
  }
}
