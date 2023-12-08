import 'package:flutter/material.dart';
import 'package:uni_map/widgets/map_details/buildings/building_info.dart';

class BuildingCard extends StatelessWidget {
  const BuildingCard({
    super.key,
    required this.pVertical,
    required this.pHorizontal,
    required this.color,
    required this.moduleText,
    required this.requestId,
    this.icon,
  });

  final double pVertical;
  final double pHorizontal;
  final Color color;
  final String moduleText;
  final IconData? icon;
  final String requestId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              BuildingInfo(buildingId: requestId),
        );
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: pVertical, horizontal: pHorizontal),
          child: Column(
            children: [
              if (icon != null) Icon(icon, color: Colors.grey.shade800),
              if (icon == null)
                Text(
                  moduleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey.shade800, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
