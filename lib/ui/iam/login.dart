import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kora_app/main.dart';
import 'package:kora_app/ui/biometric_recollection/sleep_hours.dart';
import 'package:kora_app/ui/connect_smartwatch_tuto/smartwatch_setup.dart';
import 'package:kora_app/ui/home/home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

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
  bool isSigningIn = false; // Estado para mostrar progreso al iniciar sesión
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
      isSigningIn = true; // Deshabilitar el botón cuando se presiona
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

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SmartwatchSetupView()),
      );
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    } finally {
      setState(() {
        isSigningIn = false; // Rehabilitar el botón después de la acción
      });
    }
  }

  Future<void> _signInWithMicrosoft() async {
    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          '547f0ad9-8ffa-4d32-8920-77448e13464a', // El client_id registrado en Azure
          'msauth://com.example.kora_app/callback', // URI de redirección configurada en Azure
          discoveryUrl:
              'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration',
          scopes: ['openid', 'profile', 'email', 'user.read'],
        ),
      );

      if (result != null) {
        // Usa el token de acceso o idToken para autenticación en Firebase
        final OAuthCredential credential =
            OAuthProvider("microsoft.com").credential(
          accessToken: result.accessToken,
          idToken: result.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        // Puedes acceder a la información del usuario
        User? user = FirebaseAuth.instance.currentUser;
        print('Email del usuario: ${user?.email}');
        print('Nombre del usuario: ${user?.displayName}');
      }
    } catch (e) {
      print('Error durante la autenticación con Microsoft: $e');
    }
  }

  Future<void> _signInWithMicrosoftOld() async {
    try {
      // Autoriza con Microsoft y obtiene el token de acceso e ID token
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          '547f0ad9-8ffa-4d32-8920-77448e13464a',
          'msauth://com.example.kora_app/callback', // La misma URI registrada en Azure
          discoveryUrl:
              'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration',
          scopes: [
            'openid',
            'profile',
            'email',
            'user.read'
          ], // Scopes para obtener datos del perfil y email
        ),
      );

      if (result != null) {
        print('Access token: ${result.accessToken}');
        print('ID token: ${result.idToken}');

        // Usa el token de acceso para autenticar en Firebase
        final OAuthCredential credential =
            OAuthProvider("microsoft.com").credential(
          accessToken: result.accessToken,
          idToken: result.idToken,
        );

        // Inicia sesión con Firebase usando las credenciales obtenidas de Microsoft
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        // Imprime la información del usuario
        if (user != null) {
          print("Email del usuario: ${user.email}");
          print("Nombre del usuario: ${user.displayName}");
          print("ID del usuario: ${user.uid}");
        } else {
          print("Error: No se pudo obtener la información del usuario.");
        }
      } else {
        print("Error: No se obtuvo ningún token de Microsoft.");
      }
    } catch (e) {
      print('Error durante la autenticación: $e');
    }
  }

  Future<void> _signInWithMicrosoft6() async {
    try {
      // Crea el proveedor OAuth de Microsoft
      final provider = OAuthProvider("microsoft.com");
      provider.setCustomParameters(
          {"tenant": "1bb1660c-28f6-401a-a7bc-41022e3641c2"});

      // Autenticación con Microsoft
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);

      // Obtiene el usuario autenticado
      final User? user = userCredential.user;

      // Imprime la información del usuario
      if (user != null) {
        print("Email del usuario: ${user.email}");
        print("Nombre del usuario: ${user.displayName}");

        // También puedes obtener otros datos del usuario si están disponibles
        print("ID del usuario: ${user.uid}");
      } else {
        print("Error: No se pudo obtener la información del usuario.");
      }
    } catch (e) {
      // Manejo de errores
      print("Error al iniciar sesión con Microsoft: $e");
    }
  }

  Future<void> _signInWithMicrosoftOld3() async {
    setState(() {
      isSigningIn = true; // Mostrar indicador de carga
    });

    try {
      // Crea el proveedor de Microsoft
      final OAuthProvider microsoftProvider = OAuthProvider("microsoft.com");

      // Define los permisos (scopes) que necesitas
      microsoftProvider.setScopes([
        'user.read', // Permiso para leer la información del usuario
      ]);

      // Usa el método de redirección para móviles
      await FirebaseAuth.instance.signInWithRedirect(microsoftProvider);
    } catch (e) {
      print('Error al iniciar sesión con Microsoft: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Microsoft: $e')),
      );
    } finally {
      setState(() {
        isSigningIn = false; // Ocultar el indicador de carga
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
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
          //await _microsoftSignIn.logout();
          // Aquí puedes usar el idToken y accessToken para interactuar con Firebase u otras APIs
          //await signInWithMicrosoft(token.idToken!, token.accessToken!);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
        },
      );
    } catch (e) {
      print('Excepción durante el inicio de sesión: $e');
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
    await _googleSignIn.signOut(); // Cerrar sesión de Google también
  }

  void onButtonPressed(String button) {
    setState(() {
      facebookButtonColor = Colors.white;
      googleButtonColor = Colors.white;
      appleButtonColor = Colors.white;
      microsoftButtonColor = Colors.white;

      if (button == 'facebook') {
        facebookButtonColor = backgroundColor;
        // Aquí puedes agregar la lógica para Facebook
      } else if (button == 'google') {
        googleButtonColor = backgroundColor;
        _signInWithGoogle(); // Iniciar sesión con Google
      } else if (button == 'apple') {
        appleButtonColor = backgroundColor;
        // Aquí puedes agregar la lógica para Apple ID
      } else if (button == 'microsoft') {
        microsoftButtonColor = backgroundColor;
        _loginWithMicrosoft(); // Iniciar sesión con Microsoft
      }
    });
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
                      'Login with',
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
                        'Facebook',
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
                        isSigningIn ? 'Iniciando sesión...' : 'Google',
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
                            ? 'assets/microsoft_morado.svg'
                            : 'assets/microsoft_morado.svg',
                        height: 20,
                      ),
                      label: Text(
                        'Microsoft',
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
