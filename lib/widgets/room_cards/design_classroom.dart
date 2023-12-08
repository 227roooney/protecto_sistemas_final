import 'package:flutter/material.dart';
import 'package:uni_map/widgets/room_cards/room_decorator.dart';

class DesignRoomDecorator extends RoomDecorator {
  const DesignRoomDecorator({super.key, required Widget child}) : super(child: child);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo[50],
      ),
      child: Stack(
        children: [
          child,
          const Positioned(
            right: 30,
            top: 10,
            child: Icon(Icons.color_lens, color: Colors.indigo),
          ),
        ],
      ),
    );
  }
}
