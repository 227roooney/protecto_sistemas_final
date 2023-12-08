import 'package:flutter/material.dart';
import 'package:uni_map/widgets/room_cards/room_decorator.dart';

class AuditoriumRoomDecorator extends RoomDecorator {
  const AuditoriumRoomDecorator({super.key, required Widget child}) : super(child: child);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[50],
      ),
      child: Stack(
        children: [
          child,
          const Positioned(
            right: 30,
            top: 10,
            child: Icon(Icons.co_present, color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
