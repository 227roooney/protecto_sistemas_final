import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_map/screens/lost_items/add_lost_item.dart';
import 'package:uni_map/screens/lost_items/lost_item_detail_screen.dart';
import 'package:uni_map/services/firebase_auth_service.dart';

class LostItemsScreen extends StatefulWidget {
  const LostItemsScreen({Key? key});

  @override
  _LostItemsScreenState createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  String _selectedCategory = 'Todos';
  List<String> _categories = [
    'Todos',
    'Material de estudio',
    'Electrónicos',
    'Ropa y accesorios',
    'Artículos personales',
    'Artículos deportivos',
    'Material de laboratorio',
    'Otros',
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elementos Perdidos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF974065),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (FirebaseAuthService().getCurrentUserEmail() == 'nna6000452@est.univalle.edu')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                User? currentUser = FirebaseAuth.instance.currentUser;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataEntryForm(currentUser: currentUser),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Filtrar por Categoría',
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _selectedCategory == 'Todos'
                  ? FirebaseFirestore.instance.collection('lost_items').snapshots()
                  : FirebaseFirestore.instance
                      .collection('lost_items')
                      .where('category', isEqualTo: _selectedCategory)
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay elementos perdidos disponibles'));
                }

                var lostItems = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: lostItems.length,
                  itemBuilder: (context, index) {
                    var lostItem = lostItems[index].data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LostItemDetailScreen(lostItemData: lostItem),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Nombre: ${lostItem['name']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                'Fecha: ${_formatTimestamp(lostItem['timestamp'])}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                            if (lostItem['imageUrl'] != null &&
                                lostItem['imageUrl'].isNotEmpty)
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.vertical(top: Radius.circular(15.0)),
                                child: Image.network(
                                  lostItem['imageUrl'],
                                  width: double.infinity,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context, Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(
                                        Icons.error); // Placeholder in case of error
                                  },
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Descripción: ${lostItem['description']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Ubicación: ${lostItem['location']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Categoría: ${lostItem['category']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
