import 'dart:convert';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kora_app/data/remote/KoraAPI/kora_http_helper.dart';
import 'package:kora_app/data/model/Auth/login_status.dart';
import 'package:kora_app/main.dart';
import 'package:kora_app/ui/connect_smartwatch_tuto/smartwatch_setup.dart';
import 'package:kora_app/ui/home/home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:kora_app/ui/iam/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color facebookButtonColor = Colors.white;
  Color googleButtonColor = Colors.white;
  Color appleButtonColor = Colors.white;
  Color microsoftButtonColor = Colors.white;
  Color textColor = const Color(0xFF241152);
  Color backgroundColor = const Color(0xFF241152);
  bool isFacebookSigningIn = false;
  bool isGoogleSigningIn = false;
  bool isMicrosoftSigningIn = false;
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _signOut(); // Cerrar sesión al iniciar la aplicación
    _checkForSignInWithRedirect(); // Verificar si el usuario regresa de un redireccionamiento
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isGoogleSigningIn = true; // Deshabilitar el botón cuando se presiona
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló la solicitud de inicio de sesión
        print('Inicio de sesión cancelado');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Obtén información del usuario
      final User? user = userCredential.user;
      if (user != null) {
        print('Inicio de sesión exitoso:');
        print('Nombre: ${user.displayName}');
        print('Correo electrónico: ${user.email}');
        print('Foto de perfil: ${user.photoURL}');
        print('UID: ${user.uid}');
      }

      // Guardar información del usuario y token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', googleAuth.accessToken ?? '');
      await prefs.setString('displayName', user?.displayName ?? '');
      await prefs.setString('email', user?.email ?? '');
      await prefs.setString('photoURL', user?.photoURL ?? '');
      await prefs.setString('uid', user?.uid ?? '');

      final koraHelper = KoraHelper();

      // Llamar al KoraHelper con el email del usuario
      try {
        final logStatus = await koraHelper.logIn(user?.email ?? '');
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging in: $e')),
        );
      }
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    } finally {
      setState(() {
        isGoogleSigningIn = false; // Deshabilitar el botón cuando se presiona
      });
    }
  }

  Future<void> _signInWithFacebook() async {
    setState(() {
      isFacebookSigningIn = true; // Deshabilitar el botón cuando se presiona
    });
    try {
      // Realiza el inicio de sesión con Facebook
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'], // Permisos que solicitas
        loginBehavior:
            LoginBehavior.webOnly, // Fuerza el inicio de sesión en el navegador
      );

      if (result.status == LoginStatus.success) {
        // Obtén el token de acceso
        final AccessToken accessToken = result.accessToken!;

        // Crea las credenciales para Firebase
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // Inicia sesión con Firebase
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Obtén la información del usuario
        final User? user = userCredential.user;
        if (user != null) {
          print('Inicio de sesión exitoso:');
          print('Nombre: ${user.displayName}');
          print('Correo electrónico: ${user.email}');
          print('Foto de perfil: ${user.photoURL}');
        }

        // Guardar información en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken.tokenString);
        await prefs.setString('displayName', user?.displayName ?? '');
        await prefs.setString('email', user?.email ?? '');
        await prefs.setString('photoURL', user?.photoURL ?? '');

        final koraHelper = KoraHelper();

        // Llamar al KoraHelper con el email del usuario
        try {
          final logStatus = await koraHelper.logIn(user?.email ?? '');
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error logging in: $e')),
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        print('Inicio de sesión cancelado por el usuario.');
      } else {
        print('Error durante el inicio de sesión: ${result.message}');
      }
    } catch (e) {
      print('Excepción durante el inicio de sesión con Facebook: $e');
    } finally {
      setState(() {
        isFacebookSigningIn = false; // Deshabilitar el botón cuando se presiona
      });
    }
  }

  Future<void> _checkForSignInWithRedirect() async {
    try {
      // Recupera el resultado de la autenticación si el usuario fue redirigido de vuelta
      final UserCredential userCredential =
          await FirebaseAuth.instance.getRedirectResult();

      if (userCredential.user != null) {
        // Usuario autenticado exitosamente
        _checkTutoSWConnectPassed();
      }
    } catch (e) {
      print('Error al obtener el resultado de redirección: $e');
    }
  }

  final _microsoftSignIn = AadOAuth(Config(
    tenant: "common",
    clientId: "547f0ad9-8ffa-4d32-8920-77448e13464a",
    responseType: "code", // Solicita el código de autorización
    scope:
        "openid profile email api://547f0ad9-8ffa-4d32-8920-77448e13464a/Files.Read", // Asegúrate de incluir "openid"
    redirectUri: "msal547f0ad9-8ffa-4d32-8920-77448e13464a://auth",
    loader: const Center(child: CircularProgressIndicator()),
    navigatorKey: navigatorKey, // Genera un nonce único
  ));

  _loginWithMicrosoft() async {
    setState(() {
      isMicrosoftSigningIn = true; // Deshabilitar el botón cuando se presiona
    });

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

          decodeAccessToken(token.accessToken!);
        },
      );
    } catch (e) {
      print('Excepción durante el inicio de sesión: $e');
    } finally {
      setState(() {
        isMicrosoftSigningIn =
            false; // Deshabilitar el botón cuando se presiona
      });
    }
  }

  Future<void> decodeAccessToken(String accessToken) async {
    try {
      // Divide el token en partes (Header, Payload, Signature)
      final List<String> parts = accessToken.split('.');
      if (parts.length != 3) {
        throw Exception('El token no está bien formado.');
      }

      // Decodifica el payload (la segunda parte del token)
      final String payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));

      // Convierte el payload a un Map
      final Map<String, dynamic> payloadData = jsonDecode(payload);

      // Extrae los datos que necesitas
      final String? name = payloadData['name'];
      final String? email = payloadData['email'];
      final String? preferredUsername = payloadData['preferred_username'];

      print('Nombre: $name');
      print('Correo electrónico: $email');
      print('Nombre de usuario preferido: $preferredUsername');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('displayName', name ?? '');
      await prefs.setString('email', email ?? '');
      await prefs.setString('photoURL',
          "https://images.ctfassets.net/spoqsaf9291f/5sSoTBp0HeC62pU6SXYmKj/5f2a0ee8c6310aaab7ed99645a3e3056/startup_launch_2.png");

      final koraHelper = KoraHelper();

      // Llamar al KoraHelper con el email del usuario
      try {
        final logStatus = await koraHelper.logIn(email ?? '');
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging in: $e')),
        );
      }
    } catch (e) {
      print('Error al decodificar el token: $e');
    }
  }

  Future<void> signInWithMicrosoft(String idToken, String accessToken) async {
    try {
      // Crea la credencial de Firebase con el accessToken o idToken
      final AuthCredential credential = OAuthProvider("microsoft.com")
          .credential(idToken: idToken, accessToken: accessToken);

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

  Future<void> _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _microsoftSignIn.logout();
  }

  void onButtonPressed(String button) {
    setState(() {
      facebookButtonColor = Colors.white;
      googleButtonColor = Colors.white;
      appleButtonColor = Colors.white;
      microsoftButtonColor = Colors.white;

      if (button == 'facebook') {
        facebookButtonColor = backgroundColor;
        _signInWithFacebook();
      } else if (button == 'google') {
        googleButtonColor = backgroundColor;
        _signInWithGoogle();
      } else if (button == 'apple') {
        appleButtonColor = backgroundColor;
      } else if (button == 'microsoft') {
        microsoftButtonColor = backgroundColor;
        _loginWithMicrosoft();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7654E7),
              Color(0xFF241152),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Image.asset(
                'assets/login.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    '¡Hola!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/back_hand.png',
                    height: 30,
                    width: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Empieza a experimentar la tranquilidad ahora',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  height: 1.3,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Iniciar sesión con',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        onButtonPressed('facebook');
                        // Aquí puedes agregar la lógica para Facebook
                      },
                      icon: SvgPicture.asset(
                        facebookButtonColor == backgroundColor
                            ? 'assets/facebook_blanco.svg'
                            : 'assets/facebook_morado.svg',
                        height: 20,
                      ),
                      label: Text(
                        isFacebookSigningIn
                            ? 'Iniciando sesión...'
                            : 'Facebook',
                        style: TextStyle(
                          color: facebookButtonColor == backgroundColor
                              ? Colors.white
                              : textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: facebookButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(250, 45),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () => onButtonPressed('google'),
                      icon: SvgPicture.asset(
                        googleButtonColor == backgroundColor
                            ? 'assets/google_blanco.svg'
                            : 'assets/google_morado.svg',
                        height: 20,
                      ),
                      label: Text(
                        isGoogleSigningIn ? 'Iniciando sesión...' : 'Google',
                        style: TextStyle(
                          color: googleButtonColor == backgroundColor
                              ? Colors.white
                              : textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: googleButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(250, 45),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () {
                        onButtonPressed('microsoft');
                        // Aquí se invoca la función de inicio de sesión con Microsoft
                      },
                      icon: SvgPicture.asset(
                        microsoftButtonColor == backgroundColor
                            ? 'assets/microsoft_blanco.svg'
                            : 'assets/microsoft_morado.svg',
                        height: 20,
                      ),
                      label: Text(
                        isMicrosoftSigningIn
                            ? 'Iniciando sesión...'
                            : 'Microsoft',
                        style: TextStyle(
                          color: microsoftButtonColor == backgroundColor
                              ? Colors.white
                              : textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: microsoftButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(250, 45),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
