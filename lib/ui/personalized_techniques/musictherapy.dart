import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Musictherapy extends StatefulWidget {
  const Musictherapy({super.key});

  @override
  State<Musictherapy> createState() => _MusictherapyState();
}

class _MusictherapyState extends State<Musictherapy> {
  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF4D24AF)),
      onPressed: () {
        Navigator.pop(context); // Regresar a la pantalla anterior
      },
    ),
    title: const Center(
      child: Text(
        'Musicoterapia',
        style: TextStyle(color: Color(0xFF4D24AF)),
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  backgroundColor: Colors.white,
  body: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Espacio debajo de la AppBar
        const SizedBox(height: 20),

        // Imagen con tamaño fijo
        Image.asset(
          'assets/music.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200, // Ajusta el tamaño de la imagen si es necesario
        ),

        const SizedBox(height: 20),

        // Texto debajo de la imagen
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Alivia la ansiedad con estos sonidos relajantes',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Card 1
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0), // Reduje el padding vertical
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Borde más curveado
              side: const BorderSide(color: Color(0xFFD0BFF8), width: 0.5), // Borde
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Primera imagen SVG
                  SvgPicture.asset(
                    'assets/play.svg',
                    height: 36,
                    width: 36,
                  ),
                  const SizedBox(width: 8), // Ajusta el espacio

                  // Texto con título y duración
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Alinear el texto a la izquierda
                      children: [
                        Text(
                          'Relajación profunda',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        SizedBox(height: 1), // Espacio entre el título y la duración
                        Text(
                          '3 min',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/favorite.svg',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/download.svg',
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Card 2 (similar a la Card 1)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0), // Reduje el padding vertical
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFD0BFF8), width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/play.svg',
                    height: 36,
                    width: 36,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sonidos de la naturaleza',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        SizedBox(height: 1),
                        Text(
                          '3 min',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/favorite.svg',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/download.svg',
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Card 3 (similar a la Card 1)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0), // Reduje el padding vertical
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFD0BFF8), width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/play.svg',
                    height: 36,
                    width: 36,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ondas cerebrales',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        SizedBox(height: 1),
                        Text(
                          '3 min',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/favorite.svg',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/download.svg',
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);




  }
}