import 'package:flutter/material.dart';
import 'package:http/http.dart';
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

  void sendCrypto() {
    //setting up a Webb3client which will make calls using the Http Client() to the RPC. then the web socket connector for websocket
    Web3Client myClient = Web3Client(remoteProcedureCallUrl, Client(),
        socketConnector: ()=> IOWebSocketChannel.connect(webSocketUrl).cast<String>());

    //User Details Extraction from  private key
    String fromPrivateKey = "0x77e0576d44373138daabd3a0be493737145e3ea79898d8c3f9f59af037ed8e1a";
    Credentials credentials =  EthPrivateKey.fromHex(fromPrivateKey);
    EthereumAddress fromAddress =  credentials.address;
    EthereumAddress toAddress = EthereumAddress.fromHex("0x880Bc684Af23f25a633A6Ef556627808b0fEA0AB");
    EtherAmount amountToSend =  EtherAmount.fromInt(EtherUnit.ether,90);

    //Send Ethereum
    myClient.sendTransaction(credentials, Transaction(from: fromAddress, to: toAddress, value:amountToSend,),chainId: 1337);  //always remember to add chain id

   // print("sent");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.deepPurple,
        child: const Column(
          children: [
            Text("Web 3", style: TextStyle(fontSize: 30, color: Colors.white),),
          ],
        ),
      ),),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.black,onPressed: sendCrypto,
      child: const Icon(Icons.send_outlined,color: Colors.white,)),
    );
  }
}
