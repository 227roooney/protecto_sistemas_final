import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Suggest extends StatefulWidget {
  const Suggest({super.key});

  @override
  State<Suggest> createState() => _SuggestState();
}

class _SuggestState extends State<Suggest> {
  final Stream<QuerySnapshot> _suggestionsStream =
      FirebaseFirestore.instance.collection('suggestions').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          children: [
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
              'Sugerencias',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _suggestionsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          try {
            if (snapshot.hasError) {
              return Text('Ha ocurrido un error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Cargando");
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var suggestion = snapshot.data!.docs[index];
                Timestamp timestamp = suggestion['timestamp'];
                DateTime date = timestamp.toDate();
                String formattedDate =
                    DateFormat('yyyy-MM-dd – kk:mm').format(date);
                return Card(
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Color de fondo de la tarjeta
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion['suggestion'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Color de texto blanco para contraste
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Enviado por ${suggestion['userEmail']}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors
                                .white, // Color de texto blanco para contraste
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '$formattedDate',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors
                                .white, // Color de texto blanco para contraste
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } catch (e) {
            print('Se produjo un error: $e');
            return Text('Se produjo un error: $e');
          }
        },
      ),
    );
  }
}
