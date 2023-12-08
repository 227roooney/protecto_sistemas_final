import 'package:cloud_firestore/cloud_firestore.dart';

class ModuleFavorite {
  final String userID;
  final String moduleName;
  final GeoPoint location;

  ModuleFavorite({
    required this.userID,
    required this.moduleName,
    required this.location,
  });

  factory ModuleFavorite.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ModuleFavorite(
      userID: data['userID'],
      moduleName: data['moduleName'],
      location: data['location'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userID': userID,
      'moduleName': moduleName,
      'location': location,
    };
  }
}
