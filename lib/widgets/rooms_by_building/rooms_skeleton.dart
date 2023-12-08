import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RoomsSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.6, 
              color: Colors.white,
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[200], size: 28,)
          ],
        ),
      ),
    );
  }
}
