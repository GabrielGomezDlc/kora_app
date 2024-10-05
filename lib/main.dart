import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kora_app/ui/home/home.dart';
import 'package:kora_app/ui/iam/login.dart';
//import 'package:kora_app/ui/iam/login.dart';
import 'package:kora_app/ui/personalized_techniques/musictherapy.dart';
import 'package:kora_app/ui/relax_recommendations/relax_reco.dart';
//import 'package:kora_app/ui/questionary/stai.dart';
//import 'package:kora_app/ui/questionary/stai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de que los widgets están inicializados
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 36, 17, 82)),
        useMaterial3: false,
      ),
      home: Login(),
    );
  }
}

