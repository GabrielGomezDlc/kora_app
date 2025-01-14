import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health/health.dart';
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
  
  bool wearableConnected = true;
  bool showBiometricData = false;
  bool dataCollected = false;
  bool recommendationsGenerated = false;
  int recommendedTechniqueId = 0;

  // Variables para almacenar los valores de los datos recolectados
  int bloodOxygen = 0;
  int sleepMinutes = 0;
  int heartRate = 0;

  List<HealthDataPoint> _healthDataList = [];
  final List<HealthDataType> types = [
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.HEART_RATE,
  ];
  final List<RecordingMethod> recordingMethodsToFilter = [];

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _fadeAnimationBiometric = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    _slideRecommendationsAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    _controller.forward();

    if (!wearableConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showWearableDialog(context);
      });
    } else {
      fetchData();
    }
  }

  /// Función para obtener datos de salud desde el plugin Health Connect
Future<void> fetchData() async {
  final now = DateTime.now();
  final yesterday = now.subtract(Duration(hours: 24));

  _healthDataList.clear();

  try {
    // Obtiene los datos de salud para los tipos especificados
    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
      types: types,
      startTime: yesterday,
      endTime: now,
      recordingMethodsToFilter: recordingMethodsToFilter,
    );

    // Ordena los datos por fecha (del más reciente al más antiguo)
    healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

    // Variables para almacenar el último dato de cada tipo
    int? latestBloodOxygen;
    int? latestSleepMinutes;
    int? latestHeartRate;

    // Filtra y extrae el dato más reciente de cada tipo
    for (var data in healthData) {
      if (data.value is NumericHealthValue) {
        final numericValue = (data.value as NumericHealthValue).numericValue;

        if (data.type == HealthDataType.BLOOD_OXYGEN && latestBloodOxygen == null) {
          latestBloodOxygen = numericValue.toInt();
        } else if (data.type == HealthDataType.SLEEP_SESSION && latestSleepMinutes == null) {
          latestSleepMinutes = numericValue.toInt();
        } else if (data.type == HealthDataType.HEART_RATE && latestHeartRate == null) {
          latestHeartRate = numericValue.toInt();
        }

        // Si ya se han encontrado los más recientes de todos los tipos, salir del bucle
        if (latestBloodOxygen != null && latestSleepMinutes != null && latestHeartRate != null) {
          break;
        }
      }
    }

    // Actualiza las variables globales con los valores más recientes
    setState(() {
      bloodOxygen = latestBloodOxygen ?? 0;
      sleepMinutes = latestSleepMinutes ?? 0;
      heartRate = latestHeartRate ?? 0;
      showBiometricData = true;
    });

    _controller.reset();
    _controller.forward();

    // Iniciar animación de deslizamiento para los datos recolectados
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        dataCollected = true;
      });

      _slideController.forward();

      // Iniciar predicción de técnicas
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          recommendationsGenerated = true;
          getPrediccion();
        });

        Future.delayed(const Duration(seconds: 2), () {
          navigateToNextView();
        });
      });
    });
  } catch (e) {
    print('Error al obtener datos: $e');
  }
}


  void getPrediccion() async {
    final mlhelper = MLHelper();

    // Crear una instancia de BiometricData con los valores
    final biometricData = BiometricData(
        heartRate: 80, bloodOxigen: 98, sleepMinutes: 480, staiScore: 30);

    try {
      // Realizar la predicción
      final prediction = await mlhelper.getPrediction(biometricData);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9575CD), Color(0xFF512DA8)],
          ),
        ),
        child: Center(
          child: showBiometricData
              ? FadeTransition(
                  opacity: _fadeAnimationBiometric,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Datos recolectados\n'
                        'BLOOD_OXYGEN: $bloodOxygen%\n'
                        'SLEEP_SESSION: $sleepMinutes min\n'
                        'HEART_RATE: $heartRate bpm',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Comencemos',
                        style: TextStyle(
                          fontSize: 34.0,
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



