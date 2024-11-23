
import 'package:flutter/cupertino.dart';

class Balancecards extends StatelessWidget {
  final Color thecolor;
  final Widget theChild;
  const Balancecards({super.key, required this.thecolor, required this.theChild,});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width*0.85,
        height: MediaQuery.of(context).size.height*0.25,
        decoration: BoxDecoration(
          color:thecolor,
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(image: AssetImage("assets/carddflower.png"),fit: BoxFit.cover,opacity: 0.4,)
        ),
        child: theChild,
      );
  }
}
