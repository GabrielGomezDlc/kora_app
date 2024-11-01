import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kora_app/data/model/sound.dart';
import 'package:kora_app/ui/home/home.dart';
import 'package:kora_app/ui/personalized_techniques/downloads_provider.dart';
import 'package:kora_app/ui/personalized_techniques/favorites_provider.dart';
import 'package:provider/provider.dart';

class Musictherapy extends StatefulWidget {
  const Musictherapy({super.key});

  @override
  State<Musictherapy> createState() => _MusictherapyState();
}

class _MusictherapyState extends State<Musictherapy> {
  int? selectedCardIndex;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // Función para reproducir o pausar audio
  void handlePlayPause(int cardIndex, String audioPath) async {
    if (selectedCardIndex == cardIndex) {
      await audioPlayer.pause();
      setState(() {
        selectedCardIndex = null;
      });
    } else {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource(audioPath)); // Usa AssetSource para archivos locales
      setState(() {
        selectedCardIndex = cardIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Sound> sounds = [
      Sound(title: 'Relajación profunda', audioPath: 'prueba.mp3'),
      Sound(title: 'Sonidos de la naturaleza', audioPath: 'prueba.mp3'),
      Sound(title: 'Ondas cerebrales', audioPath: 'prueba.mp3'),
    ];

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
            for (int i = 0; i < sounds.length; i++)
              buildCard(context, sounds[i], i),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, Sound sound, int cardIndex) {
    final isFavorite = context.watch<FavoritesProvider>().isFavorite(sound);
    final isDownloaded = context.watch<DownloadsProvider>().isDownloaded(sound);

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
                  handlePlayPause(cardIndex, sound.audioPath);
                },
                child: Icon(
                  selectedCardIndex == cardIndex
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: const Color(0xFF00A991),
                  size: 36,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sound.title,
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
                    onTap: () {
                      context.read<FavoritesProvider>().toggleFavorite(sound);
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFF00A991),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      await context.read<DownloadsProvider>().toggleDownload(sound);
                      final isDownloaded =
                          context.read<DownloadsProvider>().isDownloaded(sound);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isDownloaded
                                ? 'Descargado exitosamente'
                                : 'Descarga eliminada',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFF4D24AF),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Icon(
                      isDownloaded ? Icons.download_done : Icons.download,
                      color: isDownloaded ? const Color(0xFF00A991) : Colors.grey,
                      size: 24,
                    ),
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
