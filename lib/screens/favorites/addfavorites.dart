import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void addToFavorites(BuildContext context, String buildingId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final docRef = FirebaseFirestore.instance.collection('favorites').doc();
    final favID = docRef.id;
    FirebaseFirestore.instance
        .collection('buildings')
        .doc(buildingId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        Map<String, dynamic> buildingData =
            document.data() as Map<String, dynamic>;
        docRef.set({
          'favID': favID,
          'userID': user.uid,
          'moduleName': buildingData['name'],
          'location': buildingData['location'],
        }).then((result) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Added to favorites!')));
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add to favorites!')));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Building does not exist in the database')));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch building details')));
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to add favorites!')));
  }
}