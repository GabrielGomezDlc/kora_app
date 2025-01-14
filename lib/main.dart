import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:kora_app/data/remote/KoraAPI/kora_http_helper.dart';
import 'package:kora_app/data/model/Auth/login_status.dart';
import 'package:kora_app/styles/colors.dart';
import 'package:kora_app/ui/connect_smartwatch_tuto/smartwatch_setup.dart';
import 'package:kora_app/ui/data_collection_method/data_collection_method.dart';
import 'package:kora_app/ui/home/home.dart';
import 'package:kora_app/ui/iam/login.dart';

import 'package:kora_app/ui/iam/signin.dart';
import 'package:kora_app/ui/personalized_techniques/downloads_provider.dart';
import 'package:kora_app/ui/personalized_techniques/favorites_provider.dart';
import 'package:kora_app/ui/smartwatch_connection/util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegúrate de que los widgets están inicializados
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ChangeNotifierProvider(create: (_) => DownloadsProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Kora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: false,
      ),
      home: DataCollectionMethodScreen(), // Usamos la pantalla de carga inicial
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Solicitar permisos
    //getHealthConnectSdkStatus();

    await _checkIfLoggedIn();
    await _loadSelectedMethod();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final email = prefs.getString('email');

    if (accessToken != null && email != null) {
      final koraHelper = KoraHelper();

      try {
        final logStatus = await koraHelper.logIn(email);

        switch (logStatus) {
          case LogInStatus.userExists:
            _checkTutoSWConnectPassed();
            break;

          case LogInStatus.userNotFound:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Signin()),
            );
            break;

          default:
            throw Exception('Unexpected status when logging in.');
        }
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  Future<void> getHealthConnectSdkStatus() async {
    assert(Platform.isAndroid, "This is only available on Android");

    final status = await Health().getHealthConnectSdkStatus();
    print(status?.name.toUpperCase());

    if (status?.name.toUpperCase() == "SDKUNAVAILABLEPROVIDERUPDATEREQUIRED") {
      await Health().installHealthConnect();
    }
  }

  Future<void> requestHealthConnectPermissions() async {
    // configure the health plugin before use.
    Health().configure();

    List<HealthDataType> types = [
      HealthDataType.SLEEP_SESSION,
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_OXYGEN,
    ];

    bool requested = await Health().requestAuthorization(types);

    if (requested) {
      print("Permisos otorgados.");
    } else {
      print(
          "Permisos denegados. Por favor, permite el acceso en Health Connect.");
    }
  }

  Future<void> _loadSelectedMethod() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedMethod = prefs.getString('selectedMethod') ?? '';

    if (selectedMethod == "smartwatch") {
      final status = await Health().getHealthConnectSdkStatus();

      if (status?.name.toUpperCase() ==
          "SDKUNAVAILABLEPROVIDERUPDATEREQUIRED") {
        print(
            "Health Connect no está instalado. Llevando al usuario a instalarlo.");
        await Health().installHealthConnect(); // Instala Health Connect
      } else {
        print("Health Connect está instalado. Solicitando permisos.");
        await requestHealthConnectPermissions(); // Llama a la función de permisos
      }
    }
  }

  Future<void> _checkTutoSWConnectPassed() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedMethod = prefs.getString('selectedMethod') ?? '';

    if (selectedMethod == "smartwatch") {
      final tutopassed = prefs.getString('tutoSWConnectPassed') ?? '';
      if (tutopassed == "true") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SmartwatchSetupView()),
        );
      }
    }
  }
}
