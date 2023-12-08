import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_map/screens/suggestions/suggestemail.dart';

class SuggestionsScreen extends StatefulWidget {
  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final TextEditingController _suggestionController = TextEditingController();
  User? users = FirebaseAuth.instance.currentUser;

  Future<void> _sendSuggestion() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(users!.uid)
        .get();
    final userName = userData.data()?['username'];

    if (_suggestionController.text.isNotEmpty && users != null) {
      await FirebaseFirestore.instance.collection('suggestions').add({
        'suggestion': _suggestionController.text,
        'userEmail': users!.email,
        'userName': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      sendEmail(_suggestionController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sugerencia enviada'),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores personalizados
    Color burgundy = Color(0xFF974065); // Color guindo oscuro

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enviar Sugerencia',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: burgundy, // Color guindo oscuro para el AppBar
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Card(
              color: burgundy, // Color guindo oscuro para el Card
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _suggestionController,
                      decoration: InputDecoration(
                        labelText: 'Escribe tu sugerencia aquí',
                        labelStyle: TextStyle(color: Colors.white), // Texto blanco
                      ),
                      style: TextStyle(color: Colors.white), // Texto blanco
                      maxLines: 4,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _sendSuggestion,
                      child: Text('Enviar Sugerencia'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Botón blanco
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
