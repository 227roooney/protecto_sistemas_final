import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uni_map/screens/suggestions/SuggestionsScreen.dart';
import 'package:uni_map/screens/suggestions/sugges.dart';
import 'package:uni_map/widgets/profile/card_dates_profile.dart';
import 'package:uni_map/widgets/profile/delete_account.dart';
import 'package:uni_map/widgets/profile/profile_skeleton.dart';
import 'package:uni_map/widgets/profile/reset_password.dart';
import 'package:uni_map/widgets/profile/sign_off.dart';
import 'package:uni_map/widgets/profile/update_profile_card.dart';
import 'package:uni_map/services/profile_services.dart';
import 'package:uni_map/widgets/user_image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  final ProfileServices _profileServices = ProfileServices();
  File? _newProfileImage;
  String? _newUsername;
  String? _originalUsername;

  void _pickNewImage(File image) {
    setState(() {
      _newProfileImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _profileServices.getUserData(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: ProfileSkeleton());
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

        return Stack(
          children: [
            Image.asset(
              'assets/images/profile_img.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(215, 90, 0, 0),
              child: UserImagePicker(
                onPickImage: _pickNewImage,
                initialImage: userData['image_url'],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 0, 0),
              child: Text(
                'Bienvenid@, \n${userData['username']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF964164),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF964164),
                      blurRadius: 7,
                    ),
                  ],
                ),
                width: 320,
                height: 90,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      const ResetPassword(),
                      const SizedBox(width: 10),
                      const SignOff(),
                      const SizedBox(width: 10),
                      const DeleteAccount(),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => UpdateProfileCard(
                              onProfileUpdated: (updatedUsername) {
                                setState(() {
                                  _newUsername = updatedUsername;
                                });
                              },
                            ),
                          );
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 5,
                          child: Container(
                            width: 65,
                            height: 65,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Column(
                              children: [
                                SizedBox(height: 2),
                                Icon(
                                  Icons.edit,
                                  color: Color(0xFF964164),
                                  size: 22,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Editar\nPerfil',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Botón "Enviar Sugerencia" para todos los usuarios
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SuggestionsScreen(),
                            ),
                          );
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 5,
                          child: Container(
                            width: 65,
                            height: 65,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Column(
                              children: [
                                SizedBox(height: 2),
                                Icon(
                                  Icons.mail,
                                  color: Color(0xFF964164),
                                  size: 22,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Enviar\nSugerencia',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Botón "Revisar Sugerencias" solo para el usuario específico
                      if (userData['email'] == 'nna6000452@est.univalle.edu')
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Suggest(),
                              ),
                            );
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 5,
                            child: Container(
                              width: 65,
                              height: 65,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Column(
                                children: [
                                  SizedBox(height: 2),
                                  Icon(
                                    Icons.rate_review,
                                    color: Color(0xFF964164),
                                    size: 22,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Revisar\nSugerencias',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                child: CardDatesProfile(),
              ),
            ),
          ],
        );
      },
    );
  }
}
