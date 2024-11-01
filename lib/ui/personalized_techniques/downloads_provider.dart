import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:kora_app/data/model/sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadsProvider with ChangeNotifier {
  List<Sound> _downloads = [];
  List<Sound> get downloads => _downloads;

  DownloadsProvider() {
    _loadDownloads(); // Cargar descargas al iniciar
  }

  // Método para cargar las descargas desde SharedPreferences
  Future<void> _loadDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedTitles = prefs.getStringList('downloadedSounds') ?? [];

    _downloads = downloadedTitles
        .map((title) => Sound(title: title, audioPath: '')) // Configura temporalmente el audioPath vacío
        .toList();
    notifyListeners();
  }

  // Método para guardar las descargas en SharedPreferences
  Future<void> _saveDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedTitles = _downloads.map((sound) => sound.title).toList();
    await prefs.setStringList('downloadedSounds', downloadedTitles);
  }

  // Descargar y guardar un sonido o eliminarlo si ya está descargado
  Future<void> toggleDownload(Sound sound) async {
    if (isDownloaded(sound)) {
      // Eliminar descarga
      _downloads.removeWhere((s) => s.title == sound.title);
      await _deleteDownloadedFile(sound.title);
    } else {
      // Copiar archivo de assets
      final path = await _copyAssetToFile('assets/${sound.audioPath}', sound.title); // Ajusta aquí la ruta de assets
      if (path != null) {
        _downloads.add(Sound(title: sound.title, audioPath: path)); // Establece el audioPath correcto en la descarga
      } else {
        print("Error al copiar el archivo.");
        return;
      }
    }
    await _saveDownloads();
    notifyListeners();
  }

  // Verificar si el sonido está descargado
  bool isDownloaded(Sound sound) {
    return _downloads.any((downloaded) => downloaded.title == sound.title);
  }

  // Copiar archivo de assets al directorio de documentos
  Future<String?> _copyAssetToFile(String assetPath, String filename) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$filename.mp3';
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return filePath;
    } catch (e) {
      print("Error al copiar el archivo: $e");
      return null;
    }
  }

  // Eliminar archivo descargado
  Future<void> _deleteDownloadedFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename.mp3');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
