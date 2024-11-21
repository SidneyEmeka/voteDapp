import 'package:flutter/material.dart';

class Sendetherpage extends StatefulWidget {
  const Sendetherpage({super.key});

  @override
  State<Sendetherpage> createState() => _SendetherpageState();
}

class _SendetherpageState extends State<Sendetherpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.deepPurple,
        child: Column(
          children: [
            Text("Ground")
          ],
        ),
      ),),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.black,onPressed: (){},
      child: Icon(Icons.send_outlined,color: Colors.white,)),
    );
  }
}
