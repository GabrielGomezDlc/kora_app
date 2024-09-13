import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kora_app/data/model/biometric_data.dart';
import 'package:kora_app/data/model/recommended_technique.dart';

class HttpHelper {
  final String urlBase = 'http://192.168.18.19:5000'; // Base URL de la API Flask

  // Método para enviar los datos biométricos y recibir la predicción
  Future<RecommendedTechnique> getPrediction(BiometricData data) async {
    const String endpoint = '/predict';
    final String url = '$urlBase$endpoint';

    try {
      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()), // Convertir el objeto BiometricData a JSON
      );

      // Verificar si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return RecommendedTechnique.fromJson(jsonResponse); // Convertir JSON a RecommendationPrediction
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la predicción: $e');
    }
  }
}
