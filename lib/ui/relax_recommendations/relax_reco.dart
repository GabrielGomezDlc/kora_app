import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kora_app/data/model/biometric_data.dart';
import 'package:kora_app/data/remote/RelaksAPI/relaks_http_helper.dart';
import 'package:kora_app/ui/home/home.dart';
import 'package:kora_app/ui/personalized_techniques/musictherapy.dart';
import 'package:kora_app/ui/questionary/instructions.dart'; // Paquete para un spinner de carga

class RelaxationSessionView extends StatefulWidget {
  @override
  _RelaxationSessionViewState createState() => _RelaxationSessionViewState();
}

class _RelaxationSessionViewState extends State<RelaxationSessionView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeAnimationBiometric;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _slideRecommendationsAnimation;
  bool wearableConnected =
      false; // Cambia a 'true' si el smartwatch está conectado
  bool showBiometricData =
      false; // Controla la visualización de los datos biométricos
  bool dataCollected = false; // Controla cuándo mostrar "Datos recolectados"
  bool recommendationsGenerated =
      false; // Controla cuándo mostrar las recomendaciones
  int recommendedTechniqueId = 0;
  @override
  void initState() {
    super.initState();

    // Controlador para animación de deslizamiento
    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Controlador de animación de fade
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Configura la animación de fade para el primer texto
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // Configura la animación de fade para los datos biométricos
    _fadeAnimationBiometric = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // Configura la animación de deslizamiento desde abajo
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    // Configura la animación de deslizamiento para las recomendaciones
    _slideRecommendationsAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    // Inicia la animación del primer texto
    _controller.forward();

    // Si el smartwatch está conectado, mostrar "Recolectando datos biométricos..." después de un tiempo
    // Si el smartwatch no está conectado, muestra el diálogo
    if (!wearableConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showWearableDialog(context);
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          showBiometricData = true;
        });

        _controller.reset();
        _controller.forward();

        // Iniciar deslizamiento después de que se muestren los íconos
        Future.delayed(const Duration(seconds: 4), () {
          setState(() {
            dataCollected = true;
          });

          _slideController.forward();

          // Cambiar spinner a check
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              recommendationsGenerated = true;
              getPrediccion();
            });

            // Después de todo, hacer la transición a la siguiente vista
            Future.delayed(const Duration(seconds: 2), () {
              navigateToNextView();
            });
          });
        });
      });
    }
  }

  void getPrediccion() async {
    final httpHelper = HttpHelper();

    // Crear una instancia de BiometricData con los valores
    final biometricData = BiometricData(
        heartRate: 80, bloodOxigen: 98, sleepMinutes: 480, staiScore: 30);

    try {
      // Realizar la predicción
      final prediction = await httpHelper.getPrediction(biometricData);
      this.recommendedTechniqueId = prediction.recommendedTechniqueId;
      print('Técnica recomendada ID: ${prediction.recommendedTechniqueId}');
    } catch (e) {
      print('Error al obtener predicción: $e');
    }
  }

  // Función para navegar a la siguiente vista con la animación personalizada
  void navigateToNextView() {
    // Navigator.of(context).push(_createRoute());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Instructions()),
    );
  }

  // Creación de la ruta personalizada con la transición hacia arriba
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NextView(
        recommendedTechniqueId: this.recommendedTechniqueId,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Comienza desde abajo
        const end = Offset(0.0, 0.0); // Finaliza en la posición original
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  // Función para mostrar el diálogo si no hay un smartwatch conectado
  void showWearableDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      backgroundColor: const Color.fromARGB(255, 41, 27, 73),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.36,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 60, // Ancho de la píldora
                height: 8, // Altura de la píldora
                margin: const EdgeInsets.only(top: 1), // Espaciado inferior
                decoration: BoxDecoration(
                  color: const Color(0xFF9575CD), // Morado claro
                  borderRadius: BorderRadius.circular(30), // Forma redondeada
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'No hemos detectado un smartwatch conectado',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double
                    .infinity, // Hace que el botón ocupe todo el ancho posible
                child: ElevatedButton(
                  onPressed: () {
                   Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Home()), // Reemplaza con tu vista de destino
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 41, 27, 73), // Fondo transparente
                    side: const BorderSide(
                        color: Color(0xFF9575CD),
                        width: 2), // Bordes color morado claro
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Forma de píldora
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15), // Altura del botón
                  ),
                  child: const Text(
                    'Continuar sin smartwatch',
                    style: TextStyle(
                      color: Color(0xFF9575CD), // Texto color morado claro
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espaciado entre los botones
              SizedBox(
                width: double
                    .infinity, // Hace que el botón ocupe todo el ancho posible
                child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 41, 27, 73), // Fondo transparente
                    side: const BorderSide(
                        color: Color(0xFF9575CD),
                        width: 2), // Bordes color morado claro
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Forma de píldora
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15), // Altura del botón
                  ),
                  child: const Text(
                    'Verificar conexión',
                    style: TextStyle(
                      color: Color(0xFF9575CD), // Texto color morado claro
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9575CD), // Morado más claro
              Color(0xFF512DA8), // Morado más oscuro en las esquinas
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: showBiometricData
              ? FadeTransition(
                  opacity:
                      _fadeAnimationBiometric, // Animación para los datos biométricos
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Recolectando',
                        style: TextStyle(
                          fontSize: 34.0, // Letras grandes
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'datos biométricos...',
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedIconWithBorder(
                            icon: Icons.favorite,
                            fillColor: const Color(0xFF9575CD),
                            duration: 3,
                          ),
                          const SizedBox(width: 50),
                          AnimatedIconWithBorder(
                            icon: Icons.opacity,
                            fillColor: const Color(0xFF9575CD),
                            duration: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AnimatedIconWithBorder(
                        icon: Icons.nightlight_round,
                        fillColor: const Color(0xFF9575CD),
                        duration: 3,
                      ),
                      const SizedBox(height: 30),
                      if (dataCollected)
                        SlideTransition(
                          position:
                              _slideAnimation, // Animación de deslizamiento desde abajo
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 2,
                                color: const Color(0xFF9575CD),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.check,
                                      color: Color(0xFF9575CD), size: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    'Datos recolectados',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SlideTransition(
                                position: _slideRecommendationsAnimation,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    recommendationsGenerated
                                        ? const Icon(Icons.check,
                                            color: Color(0xFF9575CD), size: 30)
                                        : const SpinKitFadingCircle(
                                            color: Color(0xFF9575CD), size: 30),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Almacenando datos',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              : FadeTransition(
                  opacity: _fadeAnimation, // Animación para el primer texto
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Comencemos',
                        style: TextStyle(
                          fontSize: 34.0, // Letras grandes
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'una sesión',
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'de relajación',
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// Widget para animar el relleno de los íconos
class AnimatedIconWithBorder extends StatelessWidget {
  final IconData icon;
  final Color fillColor;
  final int duration;

  const AnimatedIconWithBorder({
    required this.icon,
    required this.fillColor,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(seconds: duration),
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: fillColor.withOpacity(0.2), // El borde transparente
            ),
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: value,
                child: Icon(
                  icon,
                  size: 80,
                  color: fillColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NextView extends StatelessWidget {
  final int recommendedTechniqueId; // Campo para recibir la técnica recomendada

  // Constructor que recibe el ID de la técnica recomendada
  NextView({required this.recommendedTechniqueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Recommended Technique ID: $recommendedTechniqueId', // Mostrar el ID
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RelaxationSessionView(),
  ));
}
