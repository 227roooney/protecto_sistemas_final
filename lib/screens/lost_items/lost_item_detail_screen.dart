import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LostItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> lostItemData;

  const LostItemDetailScreen({Key? key, required this.lostItemData}) : super(key: key);

  @override
  _LostItemDetailScreenState createState() => _LostItemDetailScreenState();
}

class _LostItemDetailScreenState extends State<LostItemDetailScreen> {
  late Map<String, dynamic> lostItemData;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    lostItemData = widget.lostItemData;
    isOwner = FirebaseAuth.instance.currentUser?.email == 'nna6000452@est.univalle.edu';
  }

  void changeItemStatus() async {
    String? itemId = lostItemData['id'];
    if (itemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ID del elemento perdido no proporcionado.')),
      );
      return;
    }

    try {
      String currentStatus = lostItemData['estado'] ?? 'Perdido';
      String newStatus = (currentStatus == 'Perdido') ? 'Encontrado' : 'Perdido';

      // Actualizar la base de datos con el nuevo estado
      await FirebaseFirestore.instance.collection('lost_items').doc(itemId).update({'estado': newStatus});

      setState(() {
        lostItemData['estado'] = newStatus;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el estado: $e')),
      );
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    } else if (timestamp is String) {
      // Si timestamp es una cadena, puede ser que ya esté en el formato deseado.
      return timestamp;
    } else {
      // Manejar otros casos según sea necesario.
      return 'Formato de fecha no válido';
    }
  }

  @override
  Widget build(BuildContext context) {
    String? itemId = lostItemData['id']; // Declarar itemId aquí

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lostItemData['name'] ?? 'Detalle del Elemento Perdido',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF974065), // Color del AppBar
        iconTheme: IconThemeData(color: Colors.white), // Color del ícono del AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(lostItemData['imageUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(17.0),
              ),
            ),
            SizedBox(height: 20),
            Text(
              lostItemData['name'] ?? 'No disponible',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ubicación: ${lostItemData['location'] ?? 'No disponible'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              'Fecha: ${_formatTimestamp(lostItemData['timestamp'])}', // Formatear la fecha
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Text(
              'Descripción:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              lostItemData['description'] ?? 'No disponible',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              'Estado: ${lostItemData['estado'] ?? 'Perdido'}',
              style: TextStyle(
                fontSize: 20,
                color: (lostItemData['estado'] == 'Encontrado') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isOwner)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                    ),
                    child: Text(
                      (lostItemData['estado'] == 'Perdido') ? 'Marcar como Encontrado' : 'Marcar como Perdido',
                    ),
                    onPressed: changeItemStatus,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                    ),
                    child: Text('Eliminar'),
                    onPressed: () => deleteItem(itemId),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'En caso de que el objeto sea de su propiedad, por favor apersonarse a bienestar estudiantil.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Función para eliminar el elemento perdido
  void deleteItem(String? itemId) async {
    try {
      await FirebaseFirestore.instance.collection('lost_items').doc(itemId).delete();
      Navigator.of(context).pop('Elemento perdido eliminado exitosamente');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el elemento: $e')),
      );
    }
  }
}
