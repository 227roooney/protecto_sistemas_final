import 'package:flutter/material.dart';
import 'package:uni_map/services/api/api_service_rooms.dart';
import 'package:uni_map/widgets/carousel/building_carousel.dart';
import 'package:uni_map/widgets/room_cards/auditorium_classroom.dart';
import 'package:uni_map/widgets/room_cards/computer_classroom.dart';
import 'package:uni_map/widgets/room_cards/design_classroom.dart';
import 'package:uni_map/widgets/room_cards/kitchen_classroom.dart';
import 'package:uni_map/widgets/room_cards/lab_classroom.dart';
import 'package:uni_map/widgets/room_cards/room_card.dart';
import 'package:uni_map/widgets/room_cards/smart_classroom.dart';
import 'package:uni_map/functions/util.dart';
import 'package:uni_map/widgets/rooms_by_building/building_skeleton.dart';
import 'package:uni_map/widgets/rooms_by_building/rooms_skeleton.dart';

class RoomsByBuilding extends StatefulWidget {
  const RoomsByBuilding({super.key, required this.id});

  final String id;

  @override
  State<StatefulWidget> createState() {
    return _RoomByBuildingState();
  }
}

class _RoomByBuildingState extends State<RoomsByBuilding> {
  late Future<List<dynamic>> roomsFuture;
  late Future<dynamic> buildingDetailsFuture;
  late Future<List<dynamic>> areasFuture;

  @override
  void initState() {
    super.initState();
    final apiService = ApiServiceRooms();
    roomsFuture = apiService.fetchRoomsByBuilding(widget.id);
    buildingDetailsFuture = apiService.fetchBuildingDetails(widget.id);
    areasFuture = apiService.fetchAreasByBuilding(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Row(
          children: [
            SizedBox(
              width: 57,
            ),
            Image(
              image: AssetImage('assets/images/logo.png'),
              height: 33,
              width: 33,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'UniMap',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
              
            ImageCarousel(id: widget.id),

            FutureBuilder<dynamic>(
              future: buildingDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BuildingSkeleton();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  var building = snapshot.data;
                  return Container(
                    padding: const EdgeInsets.all(8),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: ListTile(
                      title: Text(
                        building['name'] ?? 'No name available',
                        style: const TextStyle(fontSize: 17),
                      ),
                      subtitle: Text(
                        building['description'] ?? 'No description available',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            buildExpandableList('Aulas y Laboratorios', roomsFuture),
            buildExpandableList('Áreas Comunes y Otros', areasFuture),
          ],
        ),
      ),
    );
  }
}

Widget buildExpandableList(String title, Future<List<dynamic>> futureList) {
  return FutureBuilder<List<dynamic>>(
    future: futureList,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return RoomsSkeleton();
      } else if (snapshot.hasError ||
          !snapshot.hasData ||
          snapshot.data!.isEmpty) {
        return const SizedBox.shrink();
      } else {
        var items = snapshot.data!;
        var groupedItems = groupByLevel(items);

        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 28),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          children: groupedItems.entries.map<Widget>((entry) {
            String level = entry.key;
            List<dynamic> rooms = entry.value;
            return ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 32),
              title: Text(level),
              children: rooms.map<Widget>((item) {
                return buildRoomCard(item, title);
              }).toList(),
            );
          }).toList(),
        );
      }
    },
  );
}

Widget buildRoomCard(dynamic item, String title) {
  String itemName = item['name'].toString().toUpperCase();
  String displayText = item['id'] ?? 'No ID';
  String finalText =
      title == 'Aulas y Laboratorios' ? displayText : item['name'];
  String description = item['name'];
  String finalDescription =
      title == 'Aulas y Laboratorios' ? description : item['type'];
  Widget roomCard = RoomCard(displayText: finalText, level: finalDescription);
  if (itemName.contains('SMART')) {
    roomCard = SmartRoomDecorator(child: roomCard);
  } else if (itemName.contains('LABORATORIO') &&
      !itemName.contains('COCINA') &&
      !itemName.contains('PANADERIA') &&
      !itemName.contains('PASTELERIA') &&
      !itemName.contains('FABLAB')) {
    roomCard = LabRoomDecorator(child: roomCard);
  } else if (itemName.contains('COMPUTO')) {
    roomCard = ComputerRoomDecorator(child: roomCard);
  } else if (itemName.contains('COCINA') ||
      itemName.contains('PANADERIA') ||
      itemName.contains('PASTELERIA')) {
    roomCard = KitchenRoomDecorator(child: roomCard);
  } else if (itemName.contains('AUDITORIO')) {
    roomCard = AuditoriumRoomDecorator(child: roomCard);
  } else if (itemName.contains('FABLAB')) {
    roomCard = DesignRoomDecorator(child: roomCard);
  }
  return roomCard;
}