import 'package:flutter/material.dart';
import 'package:kora_app/ui/biometric_recollection/sleep_hours.dart';
import 'package:kora_app/styles/colors.dart';
import 'package:kora_app/styles/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartwatchSetupView extends StatefulWidget {
  @override
  _SmartwatchSetupViewState createState() => _SmartwatchSetupViewState();
}

class _SmartwatchSetupViewState extends State<SmartwatchSetupView> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Conecta tu smartwatch al celular siguiendo las instrucciones del dispositivo. Descarga la aplicación Samsung Health en tu celular.',
    'Abra Samsung Health y haga clic en Configuración.',
    'Desde el menú Configuración, seleccione Health Connect.',
    "Activa la opción 'Permitir todo' o 'Allow All' para continuar.",
    "Regresa a la sección Home y activa la opción 'Activar Auto Sincronización' o 'Turn on Auto Sync'",
    '¡Listo! La configuración está completa.',
  ];

  void _nextStep() {
    setState(() {
      if (_currentStep < _steps.length - 1) {
        _currentStep++;
      } else {
        _changeTutoConnectionStatus();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SleepTrackingView()),
        );
      }
    });
  }

  // Función para regresar al paso anterior
  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _skipTutorial() {
    _changeTutoConnectionStatus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SleepTrackingView()),
    );
  }

  Future<void> _changeTutoConnectionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tutoSWConnectPassed', "true");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipTutorial,
            child: Text(
              'Omitir',
              style: AppTextStyles.bodyText1,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
                backgroundColor: Colors.white.withOpacity(0.3),
                color: Colors.white,
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: AppColors.tercearyColor,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paso ${_currentStep + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _steps[_currentStep],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _getStepImage(),
                      width: _getStepImageSize()['width'], // Ancho específico
                      height: _getStepImageSize()['height'], // Alto específico
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _getStepLabel(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _previousStep,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 41, 27, 73),
                      ),
                      label: const Text(
                        'Anterior',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 41, 27, 73),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentStep == _steps.length - 1
                              ? 'Finalizar'
                              : 'Siguiente',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 41, 27, 73),
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Espacio entre el texto y el ícono
                        Icon(
                          _currentStep == _steps.length - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                          color: const Color.fromARGB(255, 41, 27, 73),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Función para obtener la imagen correspondiente al paso
  String _getStepImage() {
    switch (_currentStep) {
      case 0:
        return 'assets/s_health.png';
      case 1:
        return 'assets/paso2.png';
      case 2:
        return 'assets/paso3.png';
      case 3:
        return 'assets/paso4.png';
      case 4:
        return 'assets/paso5.png';
      default:
        return 'assets/ok2.png';
    }
  }

// Función para obtener el texto correspondiente al paso
  String _getStepLabel() {
    switch (_currentStep) {
      case 0:
        return 'Samsung Health';
      default:
        return '';
    }
  }

// Función para obtener el tamaño de la imagen correspondiente al paso
  Map<String, double> _getStepImageSize() {
    switch (_currentStep) {
      case 0:
        return {'width': 120.0, 'height': 120.0}; // Tamaño para el paso 1
      case 1:
        return {'width': 430.0, 'height': 430.0}; // Tamaño para el paso 2
      case 2:
        return {'width': 430.0, 'height': 430.0}; // Tamaño para el paso 3
      case 3:
        return {'width': 430.0, 'height': 430.0}; // Tamaño para el paso 3
      case 4:
        return {'width': 430.0, 'height': 430.0}; // Tamaño para el paso 3F
      default:
        return {'width': 250.0, 'height': 250.0}; // Tamaño por defecto
    }
  }
}
