import 'package:flutter/material.dart';
import 'package:uni_map/widgets/room_cards/room_decorator.dart';

class ComputerRoomDecorator extends RoomDecorator {
  const ComputerRoomDecorator({super.key, required Widget child}) : super(child: child);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
      ),
      child: Stack(
        children: [
          child,
          const Positioned(
            right: 30,
            top: 10,
            child: Icon(Icons.computer, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
