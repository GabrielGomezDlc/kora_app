import 'package:flutter/material.dart';
import 'package:kora_app/styles/colors.dart';
import 'package:kora_app/styles/texts.dart';
import 'package:kora_app/ui/personalized_techniques/breathing_exercises.dart';
import 'package:kora_app/ui/personalized_techniques/mindfulness.dart';
import 'package:kora_app/ui/personalized_techniques/musictherapy.dart';

class TechniquesSelection extends StatelessWidget {
  const TechniquesSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        // Cambiado a Center para centrar el contenido
        child: SingleChildScrollView(
          // Permite desplazar el contenido si es necesario
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                'Hemos seleccionado las siguientes técnicas para ti',
                style: AppTextStyles.headline1
              ),
              SizedBox(height: 40), // Espacio entre el título y la lista

              // Lista de técnicas
              Column(
                // Cambiado a Column para evitar problemas con el ListView dentro de un ScrollView
                children: [
                  // Técnica 1
                  TechniqueCard(
                    title: 'Respiración',
                    onStart: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BreathingExercises()), // Reemplaza con tu vista de destino
                      );
                    },
                  ),
                  SizedBox(height: 16), // Espacio entre tarjetas
                  // Técnica 2
                  TechniqueCard(
                    title: 'Musicoterapia',
                    onStart: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Musictherapy()), // Reemplaza con tu vista de destino
                      );
                    },
                  ),
                  SizedBox(height: 16), // Espacio entre tarjetas
                  // Técnica 3
                  TechniqueCard(
                    title: 'Mindfulness',
                    onStart: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Mindfulness()), // Reemplaza con tu vista de destino
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TechniqueCard extends StatelessWidget {
  final String title;
  final VoidCallback onStart;

  const TechniqueCard({super.key, required this.title, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4D24AF), // Color superior
            Color(0xFFC6BCDE), // Color inferior
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centrar contenido verticalmente
        children: [
          // Icono o imagen de la técnica
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/brain.png'), // Reemplaza con tu icono
          ),
          SizedBox(width: 16), // Espacio entre icono y texto
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centrar texto verticalmente
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Color del texto
                  ),
                ),
              ],
            ),
          ),
          // Botón "Iniciar"
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4D24AF), // Color del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Iniciar',
                style: TextStyle(
                    color: Colors.white)), // Color del texto del botón
          ),
        ],
      ),
    );
  }
}
