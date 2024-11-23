import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:votedapp/balancecards.dart';
import 'package:votedapp/bnavmorph.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Sendetherpage extends StatefulWidget {
  const Sendetherpage({super.key});

  @override
  State<Sendetherpage> createState() => _SendetherpageState();
}

class _SendetherpageState extends State<Sendetherpage> {
  String remoteProcedureCallUrl = "http://127.0.0.1:7545"; //Ganache remote server
  String webSocketUrl = "ws://127.0.0.1:7545/"; // Web socket to track changes in real time
  dynamic userBalance;
  dynamic transhash;
  Future<void> sendCrypto() async {
    //setting up a Webb3client which will make calls using the Http Client() to the RPC. then the web socket connector for websocket
    Web3Client myClient = Web3Client(remoteProcedureCallUrl, Client(),
        socketConnector: ()=> IOWebSocketChannel.connect(webSocketUrl).cast<String>());

    //User Details Extraction from  private key
    String fromPrivateKey = "0x77e0576d44373138daabd3a0be493737145e3ea79898d8c3f9f59af037ed8e1a";
    Credentials credentials =  EthPrivateKey.fromHex(fromPrivateKey);
    EthereumAddress fromAddress =  credentials.address;
    EthereumAddress toAddress = EthereumAddress.fromHex("0x880Bc684Af23f25a633A6Ef556627808b0fEA0AB");
    EtherAmount amountToSend =  EtherAmount.fromInt(EtherUnit.ether,2);

    //Send Ethereum
    myClient.sendTransaction(credentials, Transaction(from: fromAddress, to: toAddress, value:amountToSend,),chainId: 1337).then((txHash) async {
      EtherAmount newBalance = await myClient.getBalance(fromAddress);
     setState(()  {
       userBalance = newBalance.getValueInUnit(EtherUnit.ether);
       print(userBalance);
       transhash = txHash;
     });
    });  //always remember to add chain id

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.black,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Balancecards(
              theChild: Bnavmorph(blur: 5, opacity: 0.2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Flutter Dapp",
                        style: TextStyle(fontSize: 30, color: Colors.white),),
                      Text("ETH Balance ${userBalance ?? ""} ",
                        style: const TextStyle(fontSize: 15, color: Colors.white),),
                      Spacer(),
                      Visibility(visible: transhash!=null,child:  Text("Transaction Hash $transhash",
                        style: const TextStyle(fontSize: 15, color: Colors.white),),)

                    ],
                  ),
                ),
              ), thecolor: Colors.deepPurple,
            )
             ],
        ),
      ),),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.deepPurple,onPressed: sendCrypto,
      child: const Icon(Icons.send_outlined,color: Colors.white,)),
    );
  }
}
