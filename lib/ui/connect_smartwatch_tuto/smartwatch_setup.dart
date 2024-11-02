import 'package:flutter/material.dart';
import 'package:kora_app/ui/home/home.dart';

class SmartwatchSetupView extends StatefulWidget {
  @override
  _SmartwatchSetupViewState createState() => _SmartwatchSetupViewState();
}

class _SmartwatchSetupViewState extends State<SmartwatchSetupView> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Conecta tu smartwatch al celular siguiendo las instrucciones del dispositivo. Dependiendo de la marca, descarga la aplicación correspondiente en tu celular.',
    'Instala la aplicación Health Connect desde la Play Store. Ábrela y otorga los permisos de lectura y escritura para almacenar la información del smartwatch.',
    'Otorga a Kora permisos de lectura en Health Connect para sincronizar tu información.',
    '¡Listo! La configuración está completa.',
  ];

  void _nextStep() {
    setState(() {
      if (_currentStep < _steps.length - 1) {
        _currentStep++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    });
  }

  void _skipTutorial() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 27, 73),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipTutorial,
            child: Text(
              'Omitir',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              backgroundColor: Colors.white.withOpacity(0.3),
              color: Colors.white,
              minHeight: 5,
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.white.withOpacity(0.1),
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
                    SizedBox(height: 10),
                    Text(
                      _steps[_currentStep],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: _nextStep,
              icon: Icon(
                _currentStep == _steps.length - 1 ? Icons.check : Icons.arrow_forward,
                color: Color.fromARGB(255, 41, 27, 73),
              ),
              label: Text(
                _currentStep == _steps.length - 1 ? 'Finalizar' : 'Siguiente paso',
                style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 41, 27, 73)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
