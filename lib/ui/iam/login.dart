import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kora_app/ui/questionary/stai.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color facebookButtonColor = Colors.white;
  Color googleButtonColor = Colors.white;
  Color appleButtonColor = Colors.white;
  Color textColor = Color(0xFF241152); // Color del texto e imagen normal
  Color backgroundColor = Color(0xFF241152);
  Color borderColor = Color(0xFF241152);

  String selectedButton = ''; // Estado para el botón seleccionado

  void onButtonPressed(String button) {
    setState(() {
      // Restablecer todos los colores a blanco
      facebookButtonColor = Colors.white;
      googleButtonColor = Colors.white;
      appleButtonColor = Colors.white;

      // Cambiar el color del botón seleccionado
      if (button == 'facebook') {
        facebookButtonColor = backgroundColor;
        selectedButton = 'facebook'; // Guardar el botón seleccionado
      } else if (button == 'google') {
        googleButtonColor = backgroundColor;
        selectedButton = 'google'; // Guardar el botón seleccionado
      } else if (button == 'apple') {
        appleButtonColor = backgroundColor;
        selectedButton = 'apple'; // Guardar el botón seleccionado
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
              Color(0xFF7654E7), // Color superior
              Color(0xFF241152), // Color inferior
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Stai()), // Cambia 'STAI' al nombre de tu clase
                        );
                      },
                      icon: SvgPicture.asset(
                        googleButtonColor == backgroundColor
                            ? 'assets/facebook_blanco.svg' // Cambia la imagen a blanco
                            : 'assets/facebook_morado.svg', // Imagen normal
                        height: 20,
                      ),
                      label: Text(
                        'Facebook',
                        style: TextStyle(
                          color: facebookButtonColor == backgroundColor
                              ? Colors
                                  .white // Cambia el color del texto a blanco
                              : textColor, // Color normal
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
                      onPressed: () {
                        onButtonPressed('google');
                      },
                      icon: SvgPicture.asset(
                        googleButtonColor == backgroundColor
                            ? 'assets/google_blanco.svg' // Cambia la imagen a blanco
                            : 'assets/google_morado.svg', // Imagen normal
                        height: 20,
                      ),
                      label: Text(
                        'Google',
                        style: TextStyle(
                          color: googleButtonColor == backgroundColor
                              ? Colors
                                  .white // Cambia el color del texto a blanco
                              : textColor, // Color normal
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
                      },
                      icon: SvgPicture.asset(
                        appleButtonColor == backgroundColor
                            ? 'assets/apple_blanco.svg' // Cambia la imagen a blanco
                            : 'assets/apple_morado.svg', // Imagen normal
                        height: 20,
                      ),
                      label: Text(
                        'Apple ID',
                        style: TextStyle(
                          color: appleButtonColor == backgroundColor
                              ? Colors
                                  .white // Cambia el color del texto a blanco
                              : textColor, // Color normal
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
