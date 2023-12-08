import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uni_map/screens/rooms_by_building.dart';
import 'package:uni_map/services/api/api_service.dart';

class BuildingInfo extends StatelessWidget {
  final String buildingId;

  const BuildingInfo({
    Key? key,
    required this.buildingId,
  });

  Future<String> getImageUrl(String buildingId) async {
    final storage = FirebaseStorage.instance;
    var url = await storage.ref('icons/$buildingId/icon.jpg').getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiService().fetchBuildingDetails(buildingId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              '${snapshot.error}',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            elevation: 8,
            backgroundColor: Color.fromARGB(255, 131, 16, 62),
            title: Row(
              children: [
                Image.asset(
                  'assets/icon/icon.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 2.0),
                Text(
                  data['name'] ?? 'No Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(5.0),
                  width: 300,
                  height: 200,
                  child: Card(
                    margin: const EdgeInsets.all(5),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: FutureBuilder<String>(
                        future: getImageUrl(buildingId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Error'));
                          } else if (snapshot.hasData) {
                            final data = snapshot.data!;
                            return Image.network(
                              data,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  data['description'] ?? 'No Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'Ver más',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomsByBuilding(id: buildingId),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Cerrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        } else {
          return AlertDialog(
            content: Text(
              'No data available',
              style: TextStyle(color: Colors.black),
            ),
          );
        }
      },
    );
  }
}
