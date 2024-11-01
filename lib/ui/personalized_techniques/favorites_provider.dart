import 'package:flutter/material.dart';
import 'package:kora_app/data/model/sound.dart';


class FavoritesProvider with ChangeNotifier {
  List<Sound> _favorites = [];

  List<Sound> get favorites => _favorites;

  void toggleFavorite(Sound sound) {
    if (_favorites.contains(sound)) {
      _favorites.remove(sound);
    } else {
      _favorites.add(sound);
    }
    notifyListeners(); // Notifica a los widgets cuando se actualiza la lista de favoritos
  }

  bool isFavorite(Sound sound) {
    return _favorites.contains(sound);
  }
}