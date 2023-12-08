import 'package:flutter/material.dart';

abstract class RoomDecorator extends StatelessWidget {
  final Widget child;
  const RoomDecorator({super.key, required this.child});

  @override
  Widget build(BuildContext context);
}