import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kora_app/data/model/sound.dart';
import 'package:kora_app/ui/home/home.dart';
import 'package:kora_app/ui/personalized_techniques/downloads_provider.dart';
import 'package:kora_app/ui/personalized_techniques/favorites_provider.dart';
import 'package:provider/provider.dart';

class FavoritesDownloads extends StatefulWidget {
  const FavoritesDownloads({super.key});

  @override
  State<FavoritesDownloads> createState() => _FavoritesDownloadsState();
}

class _FavoritesDownloadsState extends State<FavoritesDownloads> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AudioPlayer audioPlayer = AudioPlayer();
  int? selectedCardIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  // Función para reproducir o pausar audio desde archivo local o descargado
  void handlePlayPause(int cardIndex, String audioPath, bool isDownloaded) async {
    if (selectedCardIndex == cardIndex) {
      await audioPlayer.pause();
      setState(() {
        selectedCardIndex = null;
      });
    } else {
      await audioPlayer.stop();
      // Reproducción desde un archivo descargado o desde los assets locales
      if (isDownloaded) {
        await audioPlayer.play(DeviceFileSource(audioPath));
      } else {
        await audioPlayer.play(AssetSource(audioPath));
      }
      setState(() {
        selectedCardIndex = cardIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;
    final downloads = context.watch<DownloadsProvider>().downloads;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites and Downloads'),
        backgroundColor: const Color.fromARGB(255, 36, 17, 82),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: Colors.white),
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 15.0),
          tabs: const [
            Tab(text: 'Favorites'),
            Tab(text: 'Downloads'),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 36, 17, 82),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña de favoritos con las cards
          favorites.isNotEmpty
              ? ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final sound = favorites[index];
                    return buildCard(context, sound, index, true);
                  },
                )
              : const Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          // Pestaña de descargas con las cards
          downloads.isNotEmpty
              ? ListView.builder(
                  itemCount: downloads.length,
                  itemBuilder: (context, index) {
                    final sound = downloads[index];
                    return buildCard(context, sound, index, false);
                  },
                )
              : const Center(
                  child: Text(
                    'No downloads yet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }

  // Construye la card para favoritos y descargas
  Widget buildCard(BuildContext context, Sound sound, int cardIndex, bool isFavoriteTab) {
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
              // Botón de Play/Pause
              GestureDetector(
                onTap: () {
                  handlePlayPause(cardIndex, sound.audioPath, isDownloaded);
                },
                child: Icon(
                  selectedCardIndex == cardIndex ? Icons.pause_circle : Icons.play_circle,
                  color: selectedCardIndex == cardIndex ? Color(0xFF00A991) : Color(0xFF00A991),
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
                  // Botón de Favoritos (solo mostrar en pestaña de Favoritos)
                  if (isFavoriteTab)
                    GestureDetector(
                      onTap: () {
                        context.read<FavoritesProvider>().toggleFavorite(sound);
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Color(0xFF00A991) : Colors.grey,
                        size: 24,
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Botón de Descarga (solo mostrar en pestaña de Descargas)
                  if (!isFavoriteTab)
                    GestureDetector(
                      onTap: () async {
                        await context.read<DownloadsProvider>().toggleDownload(sound);
                        final isDownloadedNow = context.read<DownloadsProvider>().isDownloaded(sound);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isDownloadedNow
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
                        color: isDownloaded ? Color(0xFF00A991) : Colors.grey,
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