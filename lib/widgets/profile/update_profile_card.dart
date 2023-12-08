import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uni_map/services/profile_services.dart';
import 'package:uni_map/widgets/user_image_picker.dart';

class UpdateProfileCard extends StatefulWidget {
  final Function(String) onProfileUpdated;
  const UpdateProfileCard({super.key, required this.onProfileUpdated});

  @override
  State<UpdateProfileCard> createState() => _UpdateProfileCardState();
}

class _UpdateProfileCardState extends State<UpdateProfileCard> {
  final ProfileServices _profileServices = ProfileServices();
  File? _newProfileImage;
  String? _newUsername;
  String? _originalUsername;

  void _pickNewImage(File image) {
    setState(() {
      _newProfileImage = image;
    });
  }

  Future<void> _updateProfile() async {
    if (_newUsername == null ||
        _newUsername!.isEmpty ||
        _newUsername!.length <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre de usuario no puede estar vacío.'),
        ),
      );
      setState(() {
        _newUsername = _originalUsername;
      });
    } else {
      await _profileServices.updateProfile(_newProfileImage, _newUsername);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Los cambios han sido actualizados.'),
        ),
      );
      widget.onProfileUpdated(_newUsername!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: _profileServices.getUserData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && _originalUsername == null) {
            _originalUsername = snapshot.data!['username'];
          }

          if (snapshot.data == null) {
            return const Center(
              child: Text("No se encontró el usuario"),
            );
          }

          final userData = snapshot.data!;
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            elevation: 8,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            title: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 2.0),
                Text(
                  userData['username'] ?? 'No username',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserImagePicker(
                    onPickImage: _pickNewImage,
                    initialImage: userData['image_url'],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Cambiar nombre de usuario',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: _originalUsername,
                    style: const TextStyle(),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    onChanged: (value) {
                      _newUsername = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _updateProfile,
                    child: Text(
                      'Actualizar',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
