import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MicrosoftLoginScreen extends StatefulWidget {
  @override
  _MicrosoftLoginScreenState createState() => _MicrosoftLoginScreenState();
}

class _MicrosoftLoginScreenState extends State<MicrosoftLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // Establece el código de idioma en inglés
    FirebaseAuth.instance.setLanguageCode("en");
  }

  Future<void> _signInWithMicrosoft() async {
    try {
      // Crear una instancia de OAuthProvider para Microsoft
      final OAuthProvider provider = OAuthProvider("microsoft.com");

      // Agregar los scopes correctos: openid y User.Read
      provider.setScopes(["openid", "User.Read"]);

      // Iniciar el flujo de autenticación con Microsoft
      UserCredential userCredential = await _auth.signInWithProvider(provider);

      // Obtener los tokens de autenticación
      final OAuthCredential credential =
          userCredential.credential as OAuthCredential;
      final String? accessToken = credential.accessToken;
      final String? idToken = credential.idToken;

      print('Access Token: $accessToken');
      print('ID Token: $idToken');

      // Autenticación exitosa, maneja el inicio de sesión
      if (userCredential.user != null) {
        print('Usuario autenticado: ${userCredential.user!.displayName}');
        // Redirigir a otra pantalla o manejar el inicio de sesión exitoso
      }
    } catch (e) {
      // Manejar el error de autenticación
      print('Error durante el inicio de sesión con Microsoft: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Microsoft Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInWithMicrosoft,
          child: Text('Iniciar sesión con Microsoft'),
        ),
      ),
    );
  }
}
