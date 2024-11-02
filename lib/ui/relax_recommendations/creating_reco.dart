import 'package:flutter/material.dart';
import 'package:kora_app/data/model/biometric_data.dart';
import 'package:kora_app/data/remote/RelaksAPI/relaks_http_helper.dart';
import 'package:kora_app/ui/personalized_techniques/breathing_exercises.dart';
import 'package:kora_app/ui/personalized_techniques/mindfulness.dart';
import 'dart:math' as math;

import 'package:kora_app/ui/personalized_techniques/musictherapy.dart';
import 'package:kora_app/ui/personalized_techniques/techniques_selection.dart';

class CustomLoadingScreen extends StatefulWidget {
  const CustomLoadingScreen({super.key});

  @override
  _CustomLoadingScreenState createState() => _CustomLoadingScreenState();
}

class _CustomLoadingScreenState extends State<CustomLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int recommendedTechniqueId = 0;
  @override
  void initState() {
    super.initState();
    // Controlador para la animación de rotación
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(); // Repite la animación indefinidamente

    // Espera 10 segundos antes de ir a otra pantalla
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        getPrediccion();
      });

/*
            if(this.recommendedTechniqueId == 0){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Musictherapy()), // Reemplaza con tu vista de destino
      );

            }else if(this.recommendedTechniqueId == 2){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mindfulness()), // Reemplaza con tu vista de destino
      );
            }else if(this.recommendedTechniqueId == 1){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BreathingExercises()), // Reemplaza con tu vista de destino
      );
            }*/
      // Aquí rediriges a la nueva vista
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const TechniquesSelection()), // Reemplaza con tu vista de destino
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getPrediccion() async {
    final httpHelper = HttpHelper();

    // Crear una instancia de BiometricData con los valores
    final biometricData = BiometricData(
        heartRate: 80, bloodOxigen: 2000, sleepMinutes: 480, staiScore: 30);

    try {
      // Realizar la predicción
      final prediction = await httpHelper.getPrediction(biometricData);
      this.recommendedTechniqueId = prediction.recommendedTechniqueId;
      print('Técnica recomendada ID: ${prediction.recommendedTechniqueId}');
    } catch (e) {
      print('Error al obtener predicción: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E004C), // Color de fondo similar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  bottom: 40.0), // Espacio entre texto y animación
              child: Text(
                'Personalizando tus recomendaciones',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // Engranaje rotatorio (puedes usar una imagen de engranaje aquí)
                RotationTransition(
                  turns: _controller, // Engranaje gira con la animación
                  child: Image.asset(
                    'assets/gear.png', // Asegúrate de tener esta imagen en tu carpeta 'assets'
                    width: 150, // Ajusta el tamaño de la imagen
                    height: 150,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de destino a la que se redirige después de los 10 segundos
class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Pantalla'),
      ),
      body: const Center(
        child: Text('¡Has llegado a la siguiente pantalla!'),
      ),
    );
  }
}
