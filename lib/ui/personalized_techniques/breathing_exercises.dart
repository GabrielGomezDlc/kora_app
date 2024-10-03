import 'package:flutter/material.dart';

class BreathingExercises extends StatefulWidget {
  const BreathingExercises({super.key});

  @override
  State<BreathingExercises> createState() => _BreathingExercisesState();
}

class _BreathingExercisesState extends State<BreathingExercises> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4D24AF)), // Ícono de flecha hacia atrás
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
        title: const Center(
          child: Text(
            'Ejercicios de Respiración',
            style: TextStyle(color: Color(0xFF4D24AF)),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinear el texto a la izquierda
          children: [
            const Text(
              'Respiración 4 - 8 - 8',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4D24AF)), // Estilo del texto
            ),
           const SizedBox(height: 20), // Espacio entre el título y las instrucciones
            _buildInstructionItem('Siéntese en una silla de apoyo o recuéstese en la cama', '1'),
            _buildInstructionItem('Inhale por la nariz durante 4 segundos.', '2'),
            _buildInstructionItem('Aguante la respiración por 8 segundos.', '3'),

            const SizedBox(height: 20), // Espacio entre las instrucciones y la imagen
            Image.asset(
              'assets/respiracion.png', // Cambia esto por la ruta de tu imagen
              width: 300, // Ajusta el ancho según sea necesario
              height: 200, // Ajusta la altura según sea necesario
              fit: BoxFit.cover,  // Ajuste de la imagen
            ),
            const SizedBox(height: 20), 
            _buildInstructionItem('Exhale por la boca con los labios fruncidos (como cuando sopla velas) durante 8 segundos.', '4'),
            _buildInstructionItem('Relájese por un segundo o dos y repita 3 veces.', '5'),
            
          ],
        ),
      ),
    );
  }

  // Método para crear un ítem de instrucción con un círculo verde
  Widget _buildInstructionItem(String text, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Espacio vertical entre los ítems
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFF00A991), // Color verde del círculo
              shape: BoxShape.circle, // Forma circular
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Color y estilo del texto
              ),
            ),
          ),
          const SizedBox(width: 10), // Espacio entre el círculo y el texto
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16), // Estilo del texto
            ),
          ),
        ],
      ),
    );
  
  }
}