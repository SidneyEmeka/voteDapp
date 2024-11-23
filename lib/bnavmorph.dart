import 'dart:ui';

import 'package:flutter/material.dart';

class Bnavmorph extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  const Bnavmorph({super.key, required this.blur, required this.opacity, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(opacity),
            borderRadius: BorderRadius.circular(10)
          ),
          child: child,
        ),),
    );
  }
}
