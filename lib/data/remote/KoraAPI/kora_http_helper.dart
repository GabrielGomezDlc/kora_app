import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:kora_app/data/model/Auth/signin_request_resource.dart';
import 'package:kora_app/data/model/PersonalInfo/personal_information_resource.dart';
import 'package:kora_app/data/model/biometric_data.dart';
import 'package:kora_app/data/model/Auth/login_request_resource.dart';
import 'package:kora_app/data/model/recommended_technique.dart';
import 'package:kora_app/data/model/Auth/login_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KoraHelper {
  final String baseUrl = 'http://192.168.1.58:61276/api/v1/';

  // Rutas base de los microservicios
  static const String identityAccess = 'identity-access';
  static const String personalInfo = 'personal-information';

  Future<String?> _getBearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<LogInStatus> logIn(String email) async {
    final String? _bearerToken = await _getBearerToken();
    if (_bearerToken == null) {
      throw Exception('The Bearer Token is not established.');
    }

    final String url = '$baseUrl$identityAccess/auth/login';

    try {
      final LoginRequestResource requestResource =
          LoginRequestResource(email: email);

      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_bearerToken',
        },
        body: jsonEncode(requestResource.toJson()),
      );

      // Verificar si la respuesta fue exitosa
      if (response.statusCode == 200) {
        return LogInStatus.userExists;
      } else if (response.statusCode == 404 &&
          response.body.contains("Not found Patient with that email")) {
        return LogInStatus.userNotFound;
      } else {
        throw Exception('Request error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  Future<LogInStatus> signIn(String fullName, String email, String photoUrl,
      int age, String gender, String surgeryType, String surgeryDate) async {
    final String? _bearerToken = await _getBearerToken();
    if (_bearerToken == null) {
      throw Exception('The Bearer Token is not established.');
    }

    final String url = '$baseUrl$identityAccess/auth/signup';

    try {
      final SigninRequestResource requestResource = SigninRequestResource(
          fullName: fullName, email: email, photoUrl: photoUrl);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_bearerToken',
        },
        body: jsonEncode(requestResource.toJson()),
      );

      if (response.statusCode == 201) {
        final LogInStatus personalInfoStatus = await registerPersonalInfo(
          age,
          gender,
          surgeryType,
          surgeryDate,
        );
        

        if (personalInfoStatus == LogInStatus.userCreated) {
          return LogInStatus.userloged;
        } else {
          throw Exception('Error registering personal info.');
        }
      } else {
        throw Exception('Error signing in: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  Future<LogInStatus> registerPersonalInfo(
      int age, String gender, String surgeryType, String surgeryDate) async {
    final String? _bearerToken = await _getBearerToken();
    if (_bearerToken == null) {
      throw Exception('The Bearer Token is not established.');
    }

    final String url =
        'http://192.168.1.58:61267/api/v1/$personalInfo/profiles';

    try {
      final PersonalInfoResource requestResource = PersonalInfoResource(
          age: age,
          gender: gender,
          surgeryType: surgeryType,
          surgeryDate: surgeryDate);

      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_bearerToken',
        },
        body: jsonEncode(requestResource.toJson()),
      );

      if (response.statusCode == 201) {
        return LogInStatus.userCreated;
        
      } else {
        throw Exception(
            'Error registering personal info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error registering personal info: $e');
    }
  }
}
