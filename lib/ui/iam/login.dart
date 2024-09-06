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
          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding horizontal
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Hace que los botones se estiren
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF241152), // Color del texto
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
                textAlign: TextAlign.center, // Centra el texto
              ),
              const SizedBox(height: 20), // Espaciado entre el texto y la imagen
              Image.asset(
                'assets/logo.png', // Carga tu imagen PNG aquí
                height: 100, // Ajusta el tamaño según sea necesario
              ),
              const SizedBox(height: 20), // Espaciado entre la imagen y el texto
              const Text(
                'Empieza a experimentar la tranquilidad ahora',
                style: TextStyle(
                  color: Colors.white, // Color del texto
                  fontWeight: FontWeight.bold, // Texto en negrita
                  fontSize: 16, // Tamaño de la fuente
                ),
                textAlign: TextAlign.center, // Centra el texto
              ),
              const SizedBox(height: 10), // Espaciado entre el texto y la línea
              const Center(
                child: Text(
                  'Login with',
                  style: TextStyle(
                    color: Colors.white, // Color del texto
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                  textAlign: TextAlign.center, // Centra el texto
                ),
              ),
              const SizedBox(height: 10), // Espaciado entre el texto y la línea
              const Divider(
                color: Colors.white, // Color de la línea
                thickness: 2, // Grosor de la línea
              ),
              const SizedBox(height: 20), // Espaciado entre la línea y los botones
              OutlinedButton.icon(
                onPressed: () {
                  // Acción para el primer botón
                },
                icon: SvgPicture.asset(
                  'assets/facebook_morado.svg', // Ícono de Facebook
                  height: 20,
                ),
                label: const Text(
                  'Facebook',
                  style: TextStyle(
                    color: Color(0xFF241152), // Color del texto
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bordes más cuadrados
                  ),
                ),
              ),
              const SizedBox(height: 10), // Espaciado entre los botones
              OutlinedButton.icon(
                onPressed: () {
                  // Acción para el segundo botón
                },
                icon: SvgPicture.asset(
                  'assets/google_morado.svg', // Ícono de Google
                  height: 20,
                ),
                label: const Text(
                  'Google',
                  style: TextStyle(
                    color: Color(0xFF241152), // Color del texto
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Espaciado entre los botones
              OutlinedButton.icon(
                onPressed: () {
                  // Acción para el tercer botón
                },
                icon: SvgPicture.asset(
                  'assets/apple_morado.svg', // Ícono de Apple
                  height: 20,
                ),
                label: const Text(
                  'Apple ID',
                  style: TextStyle(
                    color: Color(0xFF241152), // Color del texto
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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