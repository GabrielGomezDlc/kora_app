/*import 'package:flutter/material.dart';

class Home extends StatefulWidget {
   const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: const Center(
          child: Text(
            'Hola Maria',
            style: TextStyle(color: Color(0xFF4D24AF)),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      );
  }
}*/

import 'package:flutter/material.dart';
// Importa la librería de gráficos de Syncfusion
import 'package:kora_app/ui/personalized_techniques/breathing_exercises.dart';
import 'package:kora_app/ui/personalized_techniques/musictherapy.dart';
import 'package:kora_app/ui/questionary/stai.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' hide CornerStyle, AnimationType;
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSampleData {
  ChartSampleData({
    required this.x,
    required this.y,
    this.text,
    this.pointColor,
  });

  final String x; // Eje X (nombre de la técnica)
  final double y; // Eje Y (valor correspondiente)
  final String? text; // Texto opcional
  final Color? pointColor; // Color del punto opcional
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    Stai(),
    BreathingExercises(),
    Musictherapy(),
    Text('Perfil'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildIconWithIndicator({required IconData iconData, required bool isSelected}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: 24,
          color: isSelected ? const Color(0xFF4D24AF) : Colors.grey,
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF4D24AF),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIconWithIndicator(
              iconData: Icons.home_filled,
              isSelected: _selectedIndex == 0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithIndicator(
              iconData: Icons.bar_chart_rounded,
              isSelected: _selectedIndex == 1,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithIndicator(
              iconData: Icons.favorite_rounded,
              isSelected: _selectedIndex == 2,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithIndicator(
              iconData: Icons.download_rounded,
              isSelected: _selectedIndex == 3,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithIndicator(
              iconData: Icons.person_rounded,
              isSelected: _selectedIndex == 4,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF4D24AF),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Hola Maria',
            style: TextStyle(color: Color(0xFF4D24AF), fontSize: 24),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Cómo te sientes hoy?',
              style: TextStyle(fontSize: 18, color: Color(0xFF4D24AF), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEmotionColumn('assets/happy.png', 'Feliz'),
                _buildEmotionColumn('assets/tired.png', 'Cansado'),
                _buildEmotionColumn('assets/worried.png', 'Preocupado'),
                _buildEmotionColumn('assets/sad.png', 'Triste'),
                _buildEmotionColumn('assets/angry.png', 'Irritado'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard(
                  title: 'Nivel de ansiedad',
                  content: Container(
                    width: 230,
                    height: 95,
                    child: _buildRadialBarChart(),
                  ),
                ),
                _buildCard(
                  title: 'Nivel de ansiedad',
                  content: Container(
                    width: 230,
                    height: 95,
                    child: _buildAnxietyGauge(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Función que construye el gráfico radial
  Widget _buildRadialBarChart() {
    return SfCircularChart(
      key: GlobalKey(),
      series: <RadialBarSeries<ChartSampleData, String>>[
        RadialBarSeries<ChartSampleData, String>(
          maximumValue: 15,
          dataLabelSettings: const DataLabelSettings(
              isVisible: true, textStyle: TextStyle(fontSize: 10.0)),
          dataSource: <ChartSampleData>[
            ChartSampleData(
                x: 'Muy alto',
                y: 12,
                text: '80%',
                pointColor: Colors.red),
            ChartSampleData(
                x: 'Alto',
                y: 10,
                text: '60%',
                pointColor: Colors.orange),
          ],
          cornerStyle: CornerStyle.bothCurve,
          gap: '20%',
          radius: '100%',
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          pointRadiusMapper: (ChartSampleData data, _) => data.text,
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          dataLabelMapper: (ChartSampleData data, _) => data.x as String,
        ),
      ],
    );
  }

  // Función que construye el Gauge de ansiedad radial
  Widget _buildAnxietyGauge() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          ranges: <GaugeRange>[
            GaugeRange(
              label: "Bajo",
              startValue: 0,
              endValue: 33.33,
              color: Colors.green,
              startWidth: 20,
              endWidth: 20,
              labelStyle: GaugeTextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
              ),
            ),
            GaugeRange(
              label: "Medio",
              startValue: 33.33,
              endValue: 66.66,
              color: Colors.yellow,
              startWidth: 20,
              endWidth: 20,
              labelStyle: GaugeTextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
              ),
            ),
            GaugeRange(
              label: "Alto",
              startValue: 66.66,
              endValue: 100,
              color: Colors.red,
              startWidth: 20,
              endWidth: 20,
              labelStyle: GaugeTextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: 60, // Cambia este valor para probar diferentes niveles
              needleColor: const Color(0xFF4D24AF),
              knobStyle: KnobStyle(
                color: const Color(0xFF4D24AF),
                // Tamaño del knob
              ),
              needleStartWidth: 0, // Ancho de inicio del puntero
              needleEndWidth: 2, // Ancho del extremo del puntero
              // Longitud visual del puntero
            ),
            // Agregar un marcador en la posición del puntero
            MarkerPointer(
              value: 60,
              enableAnimation: true,
              markerType: MarkerType.rectangle,
              markerHeight: 10,
              markerWidth: 5,
              color: const Color(0xFF4D24AF),
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Container(
                child: const Text(
                  '60',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D24AF),
                  ),
                ),
              ),
              positionFactor: 0.5,
              angle: 90,
            ),
          ],
        )
      ],
    );
  }

  // Función que construye la leyenda para el gráfico
  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.red, 'Muy alto (80%)'),
        const SizedBox(width: 15),
        _buildLegendItem(Colors.orange, 'Alto (60%)'),
      ],
    );
  }

  // Función que crea un ítem de leyenda
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 160,
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D24AF),
              ),
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionColumn(String assetPath, String emotion) {
    return Column(
      children: [
        Image.asset(
          assetPath,
          width: 50,
          height: 50,
        ),
        const SizedBox(height: 5),
        Text(emotion),
      ],
    );
  }
}
