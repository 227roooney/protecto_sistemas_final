import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_map/screens/favorites/_RoomByBuildingState%20.dart';

class GeoFavoritesPage extends StatefulWidget {
  @override
  _GeoFavoritesPageState createState() => _GeoFavoritesPageState();
}

class _GeoFavoritesPageState extends State<GeoFavoritesPage> {
  final user = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _favoritesStream;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _favoritesStream = FirebaseFirestore.instance
          .collection('favorites')
          .where('userID', isEqualTo: user?.uid)
          .snapshots();
    }
  }

  LatLng? _convertStringToLatLng(String? locationString) {
    if (locationString == null) {
      return null;
    }
    List<String> parts = locationString.split(', ');
    if (parts.length != 2) {
      return null;
    }
    return LatLng(double.parse(parts[0]), double.parse(parts[1]));
  }

  void _deleteFavorite(String favID) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminado'),
          content: Text('¿Estás seguro de eliminar este favorito?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(favID)
          .delete()
          .then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Favorito eliminado')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo eliminar el favorito: $error')));
      });
    }
  }

  Widget _buildFavoriteCard(
      Map<String, dynamic> data, LatLng? location, String favID) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: ListTile(
        leading: Icon(Icons.place),
        title: Text(data['moduleName'] ?? 'Unknown'),
        subtitle: location != null
            ? Text('Lat: ${location.latitude}, Lng: ${location.longitude}')
            : Text('Location not available'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteFavorite(favID),
        ),
        onTap: () {
          if (location != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MapPopup(
                      location: location,
                      moduleName: data['moduleName'],
                    )));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Geo-Favoritos',
          style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Color(0xFF974065), // Color del AppBar
        iconTheme: IconThemeData(color: Colors.white), // Color del ícono del AppBar
      ),
      body: user == null
          ? Center(
              child: Text('Por favor, inicia sesión para ver tus favoritos.'))
          : StreamBuilder<QuerySnapshot>(
              stream: _favoritesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Algo salió mal al obtener los favoritos.');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    LatLng? location =
                        _convertStringToLatLng(data['location'] as String?);
                    String favID = document.id;

                    return _buildFavoriteCard(data, location, favID);
                  }).toList(),
                );
              },
            ),
    );
  }
}
