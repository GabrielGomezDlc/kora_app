class BiometricData {
  final int heartRate;
  final int bloodOxigen;
  final int sleepMinutes;
  final int staiScore;

  BiometricData({
    required this.heartRate,
    required this.bloodOxigen,
    required this.sleepMinutes,
    required this.staiScore
  });

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'HR': heartRate,
      'SpO2': bloodOxigen,
      'Sleep_Minutes': sleepMinutes,
      'Puntaje_STAI': staiScore
    };
  }
}
