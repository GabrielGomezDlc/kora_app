import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kora_app/ui/home/home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color facebookButtonColor = Colors.white;
  Color googleButtonColor = Colors.white;
  Color appleButtonColor = Colors.white;
  Color textColor = const Color(0xFF241152);
  Color backgroundColor = const Color(0xFF241152);
  bool isSigningIn = false; // Estado para mostrar progreso al iniciar sesión

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _signOut(); // Cerrar sesión al iniciar la aplicación

    
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isSigningIn = true; // Deshabilitar el botón cuando se presiona
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló la solicitud de inicio de sesión
        print('Inicio de sesión cancelado');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    } finally {
      setState(() {
        isSigningIn = false; // Rehabilitar el botón después de la acción
      });
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); // Cerrar sesión de Google también
  }

  void onButtonPressed(String button) {
    setState(() {
      facebookButtonColor = Colors.white;
      googleButtonColor = Colors.white;
      appleButtonColor = Colors.white;

      if (button == 'facebook') {
        facebookButtonColor = backgroundColor;
        // Aquí puedes agregar la lógica para Facebook
      } else if (button == 'google') {
        googleButtonColor = backgroundColor;
        _signInWithGoogle(); // Iniciar sesión con Google
      } else if (button == 'apple') {
        appleButtonColor = backgroundColor;
        // Aquí puedes agregar la lógica para Apple ID
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7654E7),
              Color(0xFF241152),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Image.asset(
                'assets/login.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    '¡Hola!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/back_hand.png',
                    height: 30,
                    width: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Empieza a experimentar la tranquilidad ahora',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  height: 1.3,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Login with',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        onButtonPressed('facebook');
                        // Aquí puedes agregar la lógica para Facebook
                      },
                      icon: SvgPicture.asset(
                        facebookButtonColor == backgroundColor
                            ? 'assets/facebook_blanco.svg'
                            : 'assets/facebook_morado.svg',
                        height: 20,
                      ),
                      label: Text(
                        'Facebook',
                        style: TextStyle(
                          color: facebookButtonColor == backgroundColor
                              ? Colors.white
                              : textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: facebookButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(250, 45),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () => onButtonPressed('google'),
                      icon: SvgPicture.asset(
                        googleButtonColor == backgroundColor
                            ? 'assets/google_blanco.svg'
                            : 'assets/google_morado.svg',
                        height: 20,
                      ),
                      label: Text(
                        isSigningIn ? 'Iniciando sesión...' : 'Google',
                        style: TextStyle(
                          color: googleButtonColor == backgroundColor
                              ? Colors.white
                              : textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: googleButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(250, 45),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () {
                        onButtonPressed('apple');
                        // Aquí puedes agregar la lógica para Apple ID
                      },
                      icon: SvgPicture.asset(
                        appleButtonColor == backgroundColor
                            ? 'assets/apple_blanco.svg'
                            : 'assets/apple_morado.svg',
                        height: 20,
                      ),
                      label: Text(
                        'Apple ID',
                        style: TextStyle(
                          color: appleButtonColor == backgroundColor
                              ? Colors.white
                              : textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: appleButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(250, 45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

