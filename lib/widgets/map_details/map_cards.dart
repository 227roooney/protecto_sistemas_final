import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uni_map/widgets/map_details/areas/area_info.dart';
import 'package:uni_map/widgets/map_details/buildings/building_card.dart';
import 'package:uni_map/widgets/map_details/areas/area_details.dart';
import 'package:uni_map/widgets/search/search_bar.dart';

class MapCards extends StatelessWidget {
  const MapCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AreaDetail(
          image: 'football_field',
          topPosition: 418,
          rightPosition: 160,
          imageWidth: 75,
          imageHeight: 75,
          requestId: 'CF',
        ),
        const AreaDetail(
          image: 'hexagon_cowork',
          topPosition: 160,
          rightPosition: 86,
          imageWidth: 80,
          imageHeight: 80,
          requestId: 'CW1',
        ),
        Positioned(
          top: 228,
          left: 225,
          child: BuildingCard(
            pHorizontal: 4,
            pVertical: 15,
            color: Colors.indigo.shade200,
            moduleText: 'Módulo 4',
            requestId: '4',
          ),
        ),
        Positioned(
          top: 180,
          left: 90,
          child: BuildingCard(
            pHorizontal: 16,
            pVertical: 20,
            color: Colors.orange.shade300,
            moduleText: 'Módulo 2',
            requestId: '2',
          ),
        ),
        Positioned(
          top: 177,
          left: 167,
          child: Card(
            color: Colors.orange.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
            ),
          ),
        ),
        Positioned(
          top: 105,
          left: 125,
          child: BuildingCard(
            pHorizontal: 24,
            pVertical: 8,
            color: Colors.red.shade300,
            moduleText: '',
            requestId: '8',
          ),
        ),
        Positioned(
          top: 155,
          left: 120,
          child: BuildingCard(
            pHorizontal: 30,
            pVertical: 3,
            color: Colors.red.shade300,
            moduleText: '',
            requestId: '8',
          ),
        ),
        Positioned(
          top: 105,
          left: 90,
          child: BuildingCard(
            pHorizontal: 2,
            pVertical: 20,
            color: Colors.red.shade300,
            moduleText: 'Módulo\n8',
            requestId: '8',
          ),
        ),
        Positioned(
          top: 120,
          left: 222,
          child: BuildingCard(
            pHorizontal: 4,
            pVertical: 11,
            color: Colors.orange.shade100,
            moduleText: '',
            icon: Icons.fastfood,
            requestId: '5',
          ),
        ),
        Positioned(
          top: 296,
          left: 116,
          child: BuildingCard(
            pHorizontal: 20,
            pVertical: 14,
            color: Colors.green.shade200,
            moduleText: '',
            requestId: '3A',
          ),
        ),
        Positioned(
          top: 325,
          left: 124,
          child: BuildingCard(
            pHorizontal: 26,
            pVertical: 14,
            color: Colors.green.shade200,
            moduleText: '',
            requestId: '3A',
          ),
        ),
        Positioned(
          top: 290,
          left: 111,
          child: BuildingCard(
            pHorizontal: 4,
            pVertical: 14,
            color: Colors.green.shade200,
            moduleText: 'Módulo 3A',
            requestId: '3A',
          ),
        ),
        Positioned(
          top: 308,
          left: 200,
          child: BuildingCard(
            pHorizontal: 18,
            pVertical: 20,
            color: Colors.green.shade200,
            moduleText: '',
            requestId: '3B',
          ),
        ),
        Positioned(
          top: 292,
          left: 200,
          child: BuildingCard(
            pHorizontal: 8,
            pVertical: 8,
            color: Colors.green.shade200,
            moduleText: 'Módulo \n3B',
            requestId: '3B',
          ),
        ),
        Positioned(
          top: 362,
          left: 181,
          child: BuildingCard(
            pHorizontal: 2,
            pVertical: 2,
            color: Colors.green.shade200,
            moduleText: 'Módulo \n3C',
            requestId: '3C',
          ),
        ),
        Positioned(
          top: 592,
          left: 83,
          child: BuildingCard(
            pHorizontal: 2,
            pVertical: 14,
            color: Colors.blue.shade200,
            moduleText: 'Módulo 7',
            requestId: '7',
          ),
        ),
        Positioned(
          top: 64,
          left: 188,
          child: Transform.rotate(
            angle: pi / 20,
            child: BuildingCard(
              pHorizontal: 14,
              pVertical: 2,
              color: Colors.yellow.shade500,
              moduleText: '',
              requestId: '1A',
            ),
          ),
        ),
        Positioned(
          top: 57,
          left: 130,
          child: Transform.rotate(
            angle: pi / 20,
            child: BuildingCard(
              pHorizontal: 4,
              pVertical: 2,
              color: Colors.yellow.shade500,
              moduleText: 'Módulo \n1A',
              requestId: '1A',
            ),
          ),
        ),
        Positioned(
          top: 69,
          left: 214,
          child: Transform.rotate(
            angle: pi / 20,
            child: BuildingCard(
              pHorizontal: 10,
              pVertical: 6,
              color: Colors.yellow.shade500,
              moduleText: '1B',
              requestId: '1B',
            ),
          ),
        ),
        Positioned(
          top: 61,
          left: 100,
          child: Transform.rotate(
            angle: pi / 20,
            child: BuildingCard(
              pHorizontal: 3,
              pVertical: 1,
              color: Colors.orange.shade500,
              moduleText: '',
              icon: Icons.monetization_on,
              requestId: '1AB',
            ),
          ),
        ),
        Positioned(
          top: 250,
          left: 60,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    const AreaInfo(buildingId: 'PQ'),
              );
            },
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Column(
                  children: [
                    Icon(Icons.local_parking, color: Colors.grey.shade800),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          top: 8.0,
          left: 15.0,
          right: 15.0,
          child: LocationSearchBar(),
        ),
      ],
    );
  }
}
