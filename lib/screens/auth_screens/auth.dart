import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uni_map/widgets/user_image_picker.dart';
import 'package:uni_map/services/firebase_auth_service.dart';
import 'package:uni_map/functions/util.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final FirebaseAuthService _authService = FirebaseAuthService();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;
  var _obscureText = true;
  File? _selectedImage;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isAuthenticating = true;
    });

    if (_isLogin) {
      await _authService.signInWithEmailAndPassword(
          _enteredEmail, _enteredPassword);
    } else {
      await _authService.createUserWithEmailAndPassword(
          _enteredEmail, _enteredPassword, _enteredUsername, _selectedImage);
    }

    setState(() {
      _isAuthenticating = false;
    });
  }

  Future<void> _showForgotPasswordDialog() async {
    String? email;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restablecer Contraseña'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Por favor, ingresa tu correo electrónico.'),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'ejemplo@univalle.edu',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enviar'),
              onPressed: () async {
                if (email != null &&
                    email!.isNotEmpty &&
                    isValidEmail(email!)) {
                  final bool emailSent =
                      await _authService.sendPasswordResetEmail(email!);
                  if (emailSent) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Correo de restablecimiento enviado. Por favor, revisa tu bandeja de entrada.'),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Por favor, ingresa un correo electrónico válido.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, ingresa un correo electrónico válido.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset(
                  'assets/images/logo.png',
                  color: Colors.white,
                  width: 180,
                  height: 180,
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              counterText: '',
                            ),
                            maxLength: 320,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if ((value == null ||
                                  value.trim().isEmpty ||
                                  !isValidEmail(value)) && !_isLogin) {
                                return 'Por favor ingresa un email válido institucional.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Nombre de usuario',
                                  counterText: ''),
                              maxLength: 64,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 3) {
                                  return 'El nombre de usuario debe tener al menos 3 caracteres.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              counterText: '',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  )),
                            ),
                            maxLength: 128,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || !isValidPassword(value)) {
                                if (!_isLogin) {
                                  return '''La contraseña contener al menos: 
- 8 caracteres.
- Una minúscula
- Una mayúscula
- Un número
- Un caracter especial''';
                                } else {
                                  return 'La contraseña no coincide con el email ingresado';
                                }
                              }
                              _enteredPassword = value;
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirmar contraseña',
                                counterText: '',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    )),
                              ),
                              maxLength: 35,
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value != _enteredPassword) {
                                  return 'Las contraseñas no coinciden.';
                                }
                                return null;
                              },
                            ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          const SizedBox(
                            height: 12,
                          ),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(
                                  _isLogin ? 'Iniciar Sesión' : 'Registrarse'),
                            ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (!_isAuthenticating && _isLogin)
                            TextButton(
                              onPressed: _showForgotPasswordDialog,
                              child: const Text('Olvidé mi contraseña'),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? '¿No tienes cuenta? Regístrate.'
                                  : 'Ya tengo una cuenta. Iniciar Sesión.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
