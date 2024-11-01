class Sound {
  final String title;
  final String audioPath;

  Sound({required this.title, required this.audioPath});

  // Sobreescribimos el operador == y el hashCode para permitir comparaciones basadas en los valores de los atributos
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sound &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          audioPath == other.audioPath;

  @override
  int get hashCode => title.hashCode ^ audioPath.hashCode;
}
