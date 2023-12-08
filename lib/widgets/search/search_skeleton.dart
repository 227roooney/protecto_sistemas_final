import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.8, 
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.5, 
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
