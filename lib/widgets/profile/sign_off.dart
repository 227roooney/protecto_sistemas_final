import 'package:flutter/material.dart';
import 'package:uni_map/services/profile_services.dart';

class SignOff extends StatefulWidget {
  const SignOff({super.key});

  @override
  State<SignOff> createState() => _SignOffState();
}

class _SignOffState extends State<SignOff> {
  final ProfileServices _profileServices = ProfileServices();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _profileServices.signOut,
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
                Icons.logout, 
                color: Color(0xFF964164), 
                size: 22,
              ),
              SizedBox(height: 5),
              Text('Cerrar\nSesión',
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
      )
    );
  }
}