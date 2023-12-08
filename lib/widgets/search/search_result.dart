import 'package:flutter/material.dart';
import 'package:uni_map/widgets/map_details/areas/area_info.dart';
import 'package:uni_map/widgets/map_details/buildings/building_info.dart';

class SearchResult extends StatelessWidget {
  SearchResult({
    super.key,
    required this.title,
    required this.subtitle,
    required this.Id,
    required this.isBuilding,
  });

  final String title;
  final String subtitle;
  final String Id;
  final bool isBuilding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => isBuilding
              ? BuildingInfo(buildingId: Id)
              : AreaInfo(buildingId: Id),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              style: TextStyle(fontWeight: FontWeight.bold),
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
