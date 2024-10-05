import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kora_app/ui/home/home.dart';

class Musictherapy extends StatefulWidget {
  const Musictherapy({super.key});

  @override
  State<Musictherapy> createState() => _MusictherapyState();
}

class _MusictherapyState extends State<Musictherapy> {
  int? selectedCardIndex; // Mantendrá el índice de la card seleccionada
  AudioPlayer audioPlayer = AudioPlayer(); // Instancia del reproductor de audio

  // Variables para los favoritos
  bool isFavorite1 = false;
  bool isFavorite2 = false;
  bool isFavorite3 = false;

  // Variables para controlar el estado de reproducción
  bool isPlaying1 = false;
  bool isPlaying2 = false;
  bool isPlaying3 = false;

  @override
  void dispose() {
    audioPlayer.dispose(); // Asegúrate de liberar recursos
    super.dispose();
  }

  // Función para reproducir o pausar audio
  void handlePlayPause(int cardIndex, String audioPath) async {
    if (selectedCardIndex == cardIndex && (isPlaying1 || isPlaying2 || isPlaying3)) {
      // Pausar si se está reproduciendo la misma tarjeta
      await audioPlayer.pause();
      setState(() {
        isPlaying1 = false;
        isPlaying2 = false;
        isPlaying3 = false;
        selectedCardIndex = null;
      });
    } else {
      // Reproducir nuevo audio
      await audioPlayer.stop(); // Detener cualquier audio anterior
      await audioPlayer.play(AssetSource(audioPath));
      setState(() {
        selectedCardIndex = cardIndex;
        isPlaying1 = cardIndex == 0;
        isPlaying2 = cardIndex == 1;
        isPlaying3 = cardIndex == 2;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4D24AF)),
          onPressed: () {
            Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
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
            const SizedBox(height: 20),
            Image.asset(
              'assets/music.png',
              fit: BoxFit.contain,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Alivia la ansiedad con estos sonidos relajantes',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Card 1
            buildCard(
              context,
              'Relajación profunda',
              0,
              isFavorite1,
              'prueba.mp3', // Ruta del audio
              () {
                setState(() {
                  isFavorite1 = !isFavorite1;
                });
              },
            ),

            // Card 2
            buildCard(
              context,
              'Sonidos de la naturaleza',
              1,
              isFavorite2,
              'prueba.mp3', // Ruta del audio
              () {
                setState(() {
                  isFavorite2 = !isFavorite2;
                });
              },
            ),

            // Card 3
            buildCard(
              context,
              'Ondas cerebrales',
              2,
              isFavorite3,
              'prueba.mp3', // Ruta del audio
              () {
                setState(() {
                  isFavorite3 = !isFavorite3;
                });
              },
            ),
          ],
        ),
      ),
    );

  }
    // Widget para construir las cards
   // Widget para construir las cards
  Widget buildCard(
    BuildContext context,
    String title,
    int cardIndex,
    bool isFavorite,
    String audioPath,
    VoidCallback onFavoriteTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
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
              GestureDetector(
                onTap: () {
                  handlePlayPause(cardIndex, audioPath);
                },
                child: SvgPicture.asset(
                  selectedCardIndex == cardIndex
                      ? 'assets/play_on.svg' // Ícono cuando está reproduciendo
                      : 'assets/play.svg', // Ícono cuando está detenido
                  height: 36,
                  width: 36,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      '3 min',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onFavoriteTap,
                    child: SvgPicture.asset(
                      isFavorite
                          ? 'assets/favorite_added.svg'
                          : 'assets/favorite.svg',
                      height: 24,
                      width: 24,
                    ),
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
    );
  }
}
