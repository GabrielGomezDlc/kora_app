import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kora_app/styles/colors.dart';
import 'package:kora_app/styles/texts.dart';
import 'package:kora_app/ui/personalized_techniques/musictherapy.dart';
import 'package:kora_app/ui/relax_recommendations/creating_reco.dart';

class Stai extends StatefulWidget {
  const Stai({super.key});

  @override
  State<Stai> createState() => _StaiState();
}

class _StaiState extends State<Stai> {
  int currentQuestionIndex = 0;
  int totalQuestions = 20; // Total de preguntas
  int selectedAnswers = 0; // Número de preguntas respondidas
  List<int?> selectedOptions =
      List.generate(20, (_) => null); // Opciones seleccionadas

  List<Map<String, dynamic>> questions =
      []; // Aquí se cargarán las preguntas del JSON

  @override
  void initState() {
    super.initState();
    loadQuestions(); // Cargar preguntas desde el JSON
  }

  // Función para cargar el JSON desde la carpeta 'lib/Data'
  Future<void> loadQuestions() async {
    String jsonString = await rootBundle.loadString('lib/data/questions.json');
    List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      questions =
          jsonData.map((question) => question as Map<String, dynamic>).toList();
      totalQuestions =
          questions.length; // Actualiza el número total de preguntas
      selectedOptions = List.generate(totalQuestions, (_) => null);
    });
  }

  // Actualizar la opción seleccionada por el usuario
  void updateSelectedOption(int questionIndex, int value) {
    setState(() {
      if (selectedOptions[questionIndex] == null) {
        selectedAnswers++; // Incrementa solo si es la primera selección
      }
      selectedOptions[questionIndex] =
          value; // Actualiza la opción seleccionada
    });
  }

  // Pasar a las siguientes 2 preguntas
  void nextQuestions() {
    setState(() {
      if (currentQuestionIndex + 2 >= totalQuestions) {
        // Si estamos al final del cuestionario, ir a otra vista
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const CustomLoadingScreen(), // Reemplaza por tu vista final
          ),
        );
      } else {
        // Si aún quedan preguntas, avanza
        currentQuestionIndex += 2;
      }
    });
  }

  // Progreso basado en las preguntas respondidas
  double get progress => selectedAnswers / totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Ícono de flecha hacia atrás
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
        title: const Text(
          'Cuestionario STAI',
          style: AppTextStyles.headline2,
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        // Agregar SingleChildScrollView aquí
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de progreso
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE9CB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.only(
                        top: 2.0,
                        bottom: 2,
                        left: 10.0,
                        right: 10.0), // Padding interno
                    child: Text(
                      '$selectedAnswers/$totalQuestions',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFC79246),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // Esquinas redondeadas
                    child: LinearProgressIndicator(
                        value: progress, // Progreso de ejemplo
                        backgroundColor: Colors.grey[300],
                        color: const Color(0xFF6730E9)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Preguntas
              if (questions
                  .isNotEmpty) // Solo muestra las preguntas si están cargadas
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(2, (index) {
                    int questionIndex = currentQuestionIndex + index;
                    if (questionIndex < totalQuestions) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 8.0),
                            child: Text(questions[questionIndex]['question'],
                                style: AppTextStyles.headline2),
                          ),
                          // Contenedor para las opciones con borde
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFD0BFF8), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: List.generate(
                                  questions[questionIndex]['options'].length,
                                  (optionIndex) {
                                return Row(
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: const Color(
                                            0xFF00A991), // Color de los botones radio no seleccionados
                                        primaryColor: const Color(
                                            0xFF00A991), // Color del botón radio seleccionado
                                      ),
                                      child: Radio<int>(
                                        value: optionIndex,
                                        groupValue:
                                            selectedOptions[questionIndex],
                                        activeColor: const Color(0xFF00A991),
                                        onChanged: (int? value) {
                                          if (value != null) {
                                            updateSelectedOption(questionIndex,
                                                value); // Actualiza la opción seleccionada
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                        questions[questionIndex]['options']
                                            [optionIndex],
                                        style: AppTextStyles.bodyText1),
                                  ],
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                              height:
                                  20), // Aumentar la distancia entre preguntas
                        ],
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // No mostrar nada si no hay más preguntas
                    }
                  }),
                ),

              const SizedBox(height: 16),

              // Botón para enviar respuesta alineado a la derecha
              Align(
                  alignment: Alignment.centerRight, // Alinear a la derecha
                  child: ElevatedButton(
                    // Verificar que ambas preguntas tengan respuestas seleccionadas
                    onPressed: selectedOptions
                            .sublist(
                                currentQuestionIndex, currentQuestionIndex + 2)
                            .every((option) => option != null)
                        ? nextQuestions
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedOptions
                              .sublist(currentQuestionIndex,
                                  currentQuestionIndex + 2)
                              .every((option) => option != null)
                          ? Colors.white // Color del botón cuando está activo
                          : Colors.grey, // Color gris cuando está inactivo
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
