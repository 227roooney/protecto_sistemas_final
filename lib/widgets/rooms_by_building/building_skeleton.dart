import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuildingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.9, 
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.6, 
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
