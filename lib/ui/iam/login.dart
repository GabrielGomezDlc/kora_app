import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7654E7), // Color superior
              Color(0xFF241152), // Color inferior
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  // Acción para el primer botón
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/facebook_morado.svg',
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Facebook',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  // Acción para el segundo botón
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/google_morado.svg',
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Google',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  // Acción para el tercer botón
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/apple_morado.svg',
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Apple ID',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    
    }

}