import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4D24AF);
  static const Color contentColorGreen = Colors.green;
  static const Color contentColorPink = Colors.pink;
  static const Color contentColorCyan = Colors.cyan;
}

class Statitics extends StatefulWidget {
  const Statitics({super.key});

  @override
  State<Statitics> createState() => _StatiticsState();
}

class _StatiticsState extends State<Statitics> {
  bool isShowingMainData = true; // Inicializa aquí
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Estadísticas',
            style: TextStyle(color: Color(0xFF4D24AF)),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            // Contenedor para el gráfico de Ritmo cardíaco
            _buildCard('Ritmo cardíaco', ' < lunes 24 de septiembre',
                const _LineChart()),
            const SizedBox(height: 20), // Espaciado entre las tarjetas
            // Contenedor para el gráfico de Oxígeno en la sangre
            _buildCard('Oxígeno en la sangre', ' < lunes 24 de septiembre',
                const _OxygenChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String date, Widget chart) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A5B8A), Color(0xFFCC6CDA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              date,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.5),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 5,
        maxY: 120,
        minY: 60,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles(),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  SideTitles leftTitles() => SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          String text;
          switch (value.toInt()) {
            case 60:
              text = '60 ppm';
              break;
            case 80:
              text = '80 ppm';
              break;
            case 100:
              text = '100 ppm';
              break;
            case 120:
              text = '120 ppm';
              break;
            default:
              return Container();
          }

          return Text(text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.white));
        },
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '12\na.m.';
        break;
      case 1:
        text = '4\na.m.';
        break;
      case 2:
        text = '8\na.m.';
        break;
      case 3:
        text = '12\np.m.';
        break;
      case 4:
        text = '4\np.m.';
        break;
      case 5:
        text = '8\np.m.';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 25,
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white)),
    );
  }

  SideTitles bottomTitles() => SideTitles(
        showTitles: true,
        reservedSize: 60,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: false,
        color: Colors.white,
        barWidth: 1.5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(0, 80),
          FlSpot(1, 100),
          FlSpot(2, 90),
          FlSpot(3, 120),
          FlSpot(4, 70),
          FlSpot(5, 110),
        ],
      );
}

class _OxygenChart extends StatelessWidget {
  const _OxygenChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      oxygenSampleData,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get oxygenSampleData => LineChartData(
        lineTouchData: oxygenLineTouchData,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 5,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.5),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: oxygenTitlesData,
        borderData: borderData,
        lineBarsData: oxygenLineBarsData,
        minX: 0,
        maxX: 5,
        maxY: 100,
        minY: 80,
      );

  LineTouchData get oxygenLineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get oxygenTitlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: oxygenBottomTitles(),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: oxygenLeftTitles(),
        ),
      );

  List<LineChartBarData> get oxygenLineBarsData => [
        oxygenLineChartBarData,
      ];

  SideTitles oxygenLeftTitles() => SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          String text;
          switch (value.toInt()) {
            case 80:
              text = '80%';
              break;
            case 85:
              text = '85%';
              break;
            case 90:
              text = '90%';
              break;
            case 95:
              text = '95%';
              break;
            case 100:
              text = '100%';
              break;
            default:
              return Container();
          }

          return Text(text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.white));
        },
      );

  Widget oxygenBottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '12\na.m.';
        break;
      case 1:
        text = '4\na.m.';
        break;
      case 2:
        text = '8\na.m.';
        break;
      case 3:
        text = '12\np.m.';
        break;
      case 4:
        text = '4\np.m.';
        break;
      case 5:
        text = '8\np.m.';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 25,
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white)),
    );
  }

  SideTitles oxygenBottomTitles() => SideTitles(
        showTitles: true,
        reservedSize: 60,
        interval: 1,
        getTitlesWidget: oxygenBottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get oxygenLineChartBarData => LineChartBarData(
        isCurved: false,
        color: Colors.white,
        barWidth: 1.5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(0, 92),
          FlSpot(1, 94),
          FlSpot(2, 96),
          FlSpot(3, 90),
          FlSpot(4, 95),
          FlSpot(5, 98),
        ],
      );
}
