import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get user => _firebaseAuth.currentUser;

  Future<Map<String, dynamic>?> getUserData() async {
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user!.uid).get();
    return doc.data();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail() async {
    final email = user?.email;
    if (email != null) {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } else {
      throw Exception('No se encontró un email para el usuario');
    }
  }

  Future<void> updateProfile(File? newProfileImage, String? newUsername) async {
    if (user == null) return;

    if (newProfileImage != null) {
      final storageRef =
          _storage.ref().child('user_images').child('${user!.uid}.jpg');
      await storageRef.putFile(newProfileImage);
      final imageUrl = await storageRef.getDownloadURL();
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'image_url': imageUrl});
    }

    if (newUsername != null) {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'username': newUsername});
    }
  }

  Future<void> deleteProfileImage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${user!.uid}.jpg');
    try {
      await storageRef.delete();
    } catch (error) {
      return;
    }
  }

  Future<void> deleteUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .delete();
  }

  Future<void> deleteUserAccount() async {
    await user!.delete();
  }

  Future<void> deleteAccount() async {
    try {
      await user!.delete();
      await deleteProfileImage();
      await deleteUserData();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'El usuario debe volver a autenticarse antes de eliminar la cuenta.');
        return;
      } else {
        print('Ocurrió un error al eliminar la cuenta: ${e.message}');
        return;
      }
    } catch (error) {
      print('Ocurrió un error inesperado: $error');
      return;
    }
  }

  Future<bool> reauthenticateUser(String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );
      await user!.reauthenticateWithCredential(credential);
      return true;
    } catch (error) {
      print('Error durante la reautenticación: $error');
      return false;
    }
  }
}
