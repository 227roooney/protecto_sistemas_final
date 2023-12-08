import 'package:flutter/material.dart';

class MapBackground extends StatelessWidget {
  const MapBackground({super.key, required this.imagePath});
  
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.4,
        child: Transform.translate(
          offset: const Offset(12.0, 10.0), 
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
