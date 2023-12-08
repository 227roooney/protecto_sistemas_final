import 'package:flutter/material.dart';
import 'package:uni_map/screens/rooms_by_building.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BuildingHomeCard extends StatelessWidget {
  const BuildingHomeCard({
    required this.requestId,
    required this.name,
    super.key,
  });

  final String requestId;
  final String name;

  Future<String> getImageUrl(String buildingId) async {
    final storage = FirebaseStorage.instance;
    var url = await storage
        .ref('icons/$buildingId/icon.jpg') 
        .getDownloadURL();
    return url;
  }
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomsByBuilding(id: requestId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Stack(
            children: [
              FutureBuilder<String>(
                future: getImageUrl(requestId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Image.network(
                      data,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  }
                  return Container();
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Color.fromARGB(255, 117, 13, 54).withOpacity(0.6),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}