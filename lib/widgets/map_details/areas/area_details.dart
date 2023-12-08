import 'package:flutter/material.dart';
import 'package:uni_map/widgets/map_details/areas/area_info.dart';

class AreaDetail extends StatelessWidget {
  const AreaDetail({
    super.key,
    required this.image,
    required this.topPosition,
    required this.rightPosition,
    required this.imageWidth,
    required this.imageHeight,
    required this.requestId,
  });

  final String image;
  final double topPosition;
  final double rightPosition;
  final double imageWidth;
  final double imageHeight;
  final String requestId;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPosition,
      right: rightPosition,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                AreaInfo(buildingId: requestId),
          );
        },
        child: Image.asset(
          'assets/images/$image.png',
          width: imageWidth,
          height: imageHeight,
        ),
      ),
    );
  }
}
