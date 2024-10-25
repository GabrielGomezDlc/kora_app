import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kora_app/ui/iam/login.dart';
import 'package:kora_app/ui/iam/login2.dart';
//import 'package:kora_app/ui/iam/login.dart';
//import 'package:kora_app/ui/questionary/stai.dart';
//import 'package:kora_app/ui/questionary/stai.dart';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegúrate de que los widgets están inicializados
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 36, 17, 82)),
        useMaterial3: false,
      ),
      home: Login(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

class _LoginScreenState extends State<LoginScreen> {
  final _microsoftSignIn = AadOAuth(Config(
    tenant: "common",
    clientId: "547f0ad9-8ffa-4d32-8920-77448e13464a",
    responseType: "code", // Solicita el código de autorización
    scope: "openid profile email api://547f0ad9-8ffa-4d32-8920-77448e13464a/Files.Read", // Asegúrate de incluir "openid"
    redirectUri: "msal547f0ad9-8ffa-4d32-8920-77448e13464a://auth",
    loader: const Center(child: CircularProgressIndicator()),
    navigatorKey: navigatorKey, // Genera un nonce único
  ));

  _loginWithMicrosoft() async {
    try {
      var result = await _microsoftSignIn.login();

      result.fold(
        (Failure failure) {
          print('Error al autenticar: ${failure.message}');
        },
        (Token token) async {
          if (token.idToken == null || token.accessToken == null) {
            print('No se recibió un token válido');
            return;
          }

          print('Autenticado con éxito, ID Token: ${token.idToken!}');
          print('Autenticado con éxito, Access Token: ${token.accessToken!}');

          // Aquí puedes usar el idToken y accessToken para interactuar con Firebase u otras APIs
          await signInWithMicrosoft(token.idToken!, token.accessToken!);

          //await _microsoftSignIn.logout();
        },
      );
    } catch (e) {
      print('Excepción durante el inicio de sesión: $e');
    }
  }

  Future<void> signInWithMicrosoft(String idToken, String accessToken) async {
    try {
      // Crea la credencial de Firebase con el accessToken o idToken
      final AuthCredential credential =
          OAuthProvider("microsoft.com").credential(
        idToken: idToken,
        accessToken: accessToken
      );

      // Autentica el usuario en Firebase usando la credencial
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user != null) {
        print('Autenticado en Firebase con Microsoft. UID: ${user.uid}');
      } else {
        print(
            'Error: Usuario es null después del inicio de sesión en Firebase');
      }
    } catch (e) {
      print('Error al iniciar sesión en Firebase con Microsoft: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _loginWithMicrosoft(),
        child: Text('Log in with Microsoft'),
      ),
    );
  }
}
