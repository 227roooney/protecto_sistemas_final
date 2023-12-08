import 'package:flutter/material.dart';
import 'package:uni_map/services/profile_services.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ProfileServices _profileServices = ProfileServices();

  Future<void> _resetPassword() async {
    try {
      await _profileServices.sendPasswordResetEmail();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Correo de restablecimiento enviado. Por favor, revisa tu bandeja de entrada.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al enviar el correo de restablecimiento.'),
        ),
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _resetPassword,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
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
                Icons.lock, 
                color: Color(0xFF964164), 
                size: 22,
              ),
              SizedBox(height: 5),
              Text('Cambiar Contraseña',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}