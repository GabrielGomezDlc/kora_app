import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kora_app/main.dart';
import 'package:kora_app/styles/colors.dart';
import 'package:kora_app/styles/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding:
              EdgeInsets.only(top: 20.0), // Padding solo en la parte superior
          child: Text(
            'Perfil',
            style: AppTextStyles.headline1,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.primaryColor,
      body: ElevatedButton(
        onPressed: () {
          _logout();
        },
        child: const Text('Cerrar sesión'),
      ),
    );
  }

  _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); 

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
