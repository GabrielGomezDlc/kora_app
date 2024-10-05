import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kora_app/ui/questionary/stai.dart';

class Instructions extends StatefulWidget {
  const Instructions({super.key});

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de la animación
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Define la animación de entrada desde abajo
    _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Inicia la animación
    _controller.forward();

    // Configura el temporizador para navegar después de 10 segundos
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Stai()), // Cambia a tu vista siguiente
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4D24AF),
      body: SlideTransition(
        position: _animation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Instrucciones:\n\n",
                    style: TextStyle(
                      fontSize: 26.0, // Tamaño más grande para "Instrucciones"
                      color: Colors.white, // Color morado
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        "A continuación se le proporcionará unas frases que se utilizan comúnmente para describirse uno a sí mismo. "
                        "Lea cada frase y señale la puntuación de 0 a 3 que indique mejor cómo se siente usted ahora mismo, en este momento. "
                        "No hay respuestas buenas ni malas. No emplee demasiado tiempo en cada frase y conteste señalando la respuesta que mejor describa su situación presente.",
                    style: TextStyle(
                      fontSize: 20.0, // Tamaño del texto general
                      color: Colors.white, // Mismo color morado
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}