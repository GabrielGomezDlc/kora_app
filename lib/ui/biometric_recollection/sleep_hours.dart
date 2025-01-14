import 'package:flutter/material.dart';
import 'package:kora_app/ui/questionary/instructions.dart';
import 'package:kora_app/ui/relax_recommendations/relax_reco.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class SleepTrackingView extends StatefulWidget {
  const SleepTrackingView({super.key});

  @override
  _SleepTrackingViewState createState() => _SleepTrackingViewState();
}

class _SleepTrackingViewState extends State<SleepTrackingView> {
  double _sleepStart = 2.0; // Hora de dormir (2:00 AM)
  double _sleepEnd = 9.0; // Hora de despertar (9:00 AM)

  // Función para convertir horas decimales a formato de 12 horas (AM/PM)
  String _getTimeString(double value) {
    int hour = value.floor();
    bool isAm = hour < 12;
    hour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;
    String period = isAm ? 'a.m.' : 'p.m.';
    return '$hour:00 $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E0D50), // Fondo oscuro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Barra de progreso superior
            const SizedBox(height: 20),

            // Pregunta
            const Text(
              '¿Cuántas horas dormiste anoche?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Gráfico circular con Syncfusion Radial Range Slider
            Container(
              width: 300,
              height: 300,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    startAngle: 270,
                    endAngle: 270,
                    minimum: 0,
                    maximum: 12,
                    showLabels: true,
                    showTicks: false,
                    axisLabelStyle: GaugeTextStyle(
                      color: Colors
                          .white, // Cambia el color de los números del reloj a blanco
                      fontSize: 16,
                    ),
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.15,
                      color: Colors.black12,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: _sleepStart,
                        endValue: _sleepEnd,
                        color: Colors.purpleAccent,
                        startWidth: 15,
                        endWidth: 15,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      // Puntero para la hora de dormir (noche)
                      MarkerPointer(
                        value: _sleepStart,
                        markerHeight: 30,
                        markerWidth: 30,
                        color: Colors.purpleAccent,
                        markerType: MarkerType.circle,
                        onValueChanged: (newValue) {
                          setState(() {
                            _sleepStart = newValue;
                          });
                        },
                        enableDragging: true,
                      ),
                      // Puntero para la hora de despertar (día)
                      MarkerPointer(
                        value: _sleepEnd,
                        markerHeight: 30,
                        markerWidth: 30,
                        color: Colors.yellowAccent,
                        markerType: MarkerType.circle,
                        onValueChanged: (newValue) {
                          setState(() {
                            _sleepEnd = newValue;
                          });
                        },
                        enableDragging: true,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        positionFactor: 0.1,
                        angle: 90,
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(_sleepEnd - _sleepStart).abs().toStringAsFixed(1)}h',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Tiempo de sueño total',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Hora de dormir y despertar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Hora de dormir
                Column(
                  children: [
                    const Icon(Icons.nightlight_round,
                        color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      _getTimeString(_sleepStart),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Text(
                      'Hora de dormir',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                // Hora de despertar
                Column(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      _getTimeString(_sleepEnd),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Text(
                      'Despierta',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Botón de continuar
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Instructions()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(
                  color: Color(0xFF1E0D50),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
