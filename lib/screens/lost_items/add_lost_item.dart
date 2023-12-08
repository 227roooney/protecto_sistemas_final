import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class DataEntryForm extends StatefulWidget {
  final User? currentUser;

  DataEntryForm({Key? key, required this.currentUser}) : super(key: key);

  @override
  _DataEntryFormState createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  File? _image;
  bool _isUploading = false;
  String _selectedCategory = 'Material de estudio';
  List<String> _categories = [
    'Material de estudio',
    'Electrónicos',
    'Ropa y accesorios',
    'Artículos personales',
    'Artículos deportivos',
    'Material de laboratorio',
    'Otros',
  ];

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      try {
        if (_image == null) {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor selecciona una imagen.')),
          );
          return;
        }

        Uint8List resizedImage = await _resizeImage(_image!.readAsBytesSync(), 200);

        Reference storageReference =
            FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
        UploadTask uploadTask = storageReference.putData(resizedImage);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        String documentId = FirebaseFirestore.instance.collection('lost_items').doc().id;

        await FirebaseFirestore.instance.collection('lost_items').doc(documentId).set({
          'id': documentId,
          'name': _nameController.text,
          'description': _descriptionController.text,
          'location': _locationController.text,
          'category': _selectedCategory,
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          _isUploading = false;
        });

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<Uint8List> _resizeImage(Uint8List imageBytes, int size) async {
    img.Image image = img.decodeImage(imageBytes)!;
    img.Image resizedImage = img.copyResize(image, width: size);
    return Uint8List.fromList(img.encodePng(resizedImage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Añadir objeto perdido',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF974065),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una descripción';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Lugar'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un lugar';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
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
                    labelText: 'Categoría',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona una categoría';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text('Seleccionar imagen'),
                ),
                _image != null
                    ? Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_image!),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                _isUploading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _isUploading ? null : _saveData,
                        child: Text('Guardar'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
