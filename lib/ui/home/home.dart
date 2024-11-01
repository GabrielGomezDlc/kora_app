import 'package:flutter/material.dart';
import 'package:kora_app/ui/personalized_techniques/breathing_exercises.dart';
import 'package:kora_app/ui/personalized_techniques/favorites_downloads.dart';
import 'package:kora_app/ui/personalized_techniques/musictherapy.dart';
import 'package:kora_app/ui/questionary/stai.dart';
import 'package:kora_app/ui/relax_recommendations/relax_reco.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'
    hide CornerStyle, AnimationType;
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
    FavoritesDownloads(),
    Musictherapy(),
    Text('Perfil'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildIconWithIndicator(
      {required IconData iconData, required bool isSelected}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: 24,
          color: isSelected
              ? Colors.white
              : const Color.fromARGB(255, 115, 115, 115),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 17, 82),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 41, 27, 73),
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
              iconData: Icons.history,
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
        selectedItemColor: const Color.fromARGB(255, 204, 204, 204),
        unselectedItemColor: const Color.fromARGB(255, 115, 115, 115),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
   String? _selectedEmotion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(
              top: 20.0), // Padding solo en la parte superior
          child: Text(
            'Hola Cris,',
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 41, 27, 73),
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 41, 27, 73),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 12, bottom: 16.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Cómo te sientes hoy?',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
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
                  title: 'Datos Biometricos',
                  content: Container(
                    width: 260,
                    height: 110,
                    child: _buildRadialBarChart(),
                  ),
                ),
                _buildCard(
                  title: 'Nivel de ansiedad',
                  content: Container(
                    width: 240,
                    height: 120,
                    child: _buildAnxietyGauge(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            const Padding(
              padding:
                  EdgeInsets.only(bottom: 16.0, left: 8), // Espacio inferior
              child: Text(
                'Recomendación',
                style: TextStyle(
                  fontSize: 24, // Tamaño del texto del título
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Negrita para el título
                ),
              ),
            ),
            _buildRecommendationCard(
              imagePath: 'assets/relajación.png',
              title: 'Relajación',
              subtitle: 'Sesión de',
              buttonText: 'Iniciar',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RelaxationSessionView()),
                );
              },
            ),
            const SizedBox(height: 14),
            _buildRecommendationCard(
              imagePath: 'assets/cirugía.png',
              title: 'Cirugía',
              subtitle: 'Información de',
              buttonText: 'Ver',
              onPressed: () {
                // Acción del botón de "Ver"
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget para las tarjetas de recomendación (relajación y cirugía)
  Widget _buildRecommendationCard({
    required String imagePath,
    required String title, // Texto grande
    required String subtitle, // Texto pequeño
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      color: Color.fromARGB(255, 208, 191, 248),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8.0, // Controla la altura de la sombra (más alto, más 3D)
      shadowColor: Colors.black
          .withOpacity(0.9), // Controla el color y la opacidad de la sombra
      child: Row(
        children: [
          // Imagen con padding a izquierda y derecha
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0, // Padding superior
              bottom: 8.0, // Padding inferior
              left: 22.0, // Padding izquierdo
              right: 8.0, // Padding derecho
            ), // Ajusta el padding horizontal
            child: Image.asset(
              imagePath,
              height: 120, // Ajusta el tamaño de la imagen
              width: 120,
              fit: BoxFit
                  .cover, // Ajusta cómo la imagen se adapta a su contenedor
            ),
          ),
          const SizedBox(width: 2.0),
          // Texto y botón
          Expanded(
            flex: 2, // Flex para asignar más espacio al texto y botón
            child: Padding(
              padding: const EdgeInsets.only(
                top: 22.0, // Padding superior
                bottom: 8.0, // Padding inferior
                left: 8.0, // Padding izquierdo
                right: 8.0, // Padding derecho
              ), // Ajusta el padding según sea necesario
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subtítulo pequeño arriba del título grande
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100, // Tamaño de fuente pequeño
                      color: Color.fromRGBO(37, 17, 82, 1), // Color más claro
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32, // Tamaño de fuente grande
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(37, 17, 82, 1), // Color más oscuro
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Botón
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 104, 48, 233), // Color del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(80, 30),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 18, // Tamaño de la fuente del texto
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                x: '89 ppm', y: 12, text: '80%', pointColor: Color(0xFF4D24AF)),
            ChartSampleData(
                x: '95%', y: 10, text: '60%', pointColor: Color(0xFF00A991))
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
    return Padding(
      padding:
          const EdgeInsets.only(top: 20.0), // Aplica padding a todos los lados
      child: SfRadialGauge(
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
                color: const Color.fromARGB(255, 87, 213, 91),
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
                color: const Color.fromARGB(255, 248, 235, 117),
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
                color: const Color.fromARGB(255, 248, 101, 91),
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
            pointers: const <GaugePointer>[
              NeedlePointer(
                value: 60, // Cambia este valor para probar diferentes niveles
                needleColor: Color(0xFF4D24AF),
                knobStyle: KnobStyle(
                  color: Color(0xFF4D24AF),
                ),
                needleStartWidth: 0, // Ancho de inicio del puntero
                needleEndWidth: 2, // Ancho del extremo del puntero
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Container(
                  child: const Text(
                    '',
                    style: TextStyle(
                      fontSize: 16, // Ajusta el tamaño de la anotación
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
      ),
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
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              30), // Mismo borde redondeado que la tarjeta
          border: Border.all(
            color: Color.fromRGBO(208, 191, 248, 1), // Color del borde
            width: 1.0, // Grosor del borde
          ),
        ),
        padding: const EdgeInsets.all(15),
        width: 160,
        height: 192, // Ajusta la altura para que todo quepa bien
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Alinea todo a la izquierda
          children: [
            // Texto principal
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 41, 27, 73),
              ),
            ),
            // Contenido dinámico
            content,
            // Solo mostrar si el título es 'Datos Biométricos'
            title == 'Datos Biometricos'
                ? Column(
                    children: [
                      // Primer cuadrado con texto
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(
                                  0xFF4D24AF), // Color de fondo del cuadrado
                              borderRadius: BorderRadius.circular(
                                  2), // Bordes redondeados
                            ),
                          ),
                          const SizedBox(
                              width: 8), // Espacio entre el cuadrado y el texto
                          const Text(
                            'Ritmo Cardiaco',
                            style: TextStyle(fontSize: 14), // Tamaño del texto
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 4), // Espacio entre los dos cuadrados
                      // Segundo cuadrado con texto
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(
                                  0xFF00A991), // Color de fondo del cuadrado
                              borderRadius: BorderRadius.circular(
                                  2), // Bordes redondeados
                            ),
                          ),
                          const SizedBox(
                              width: 8), // Espacio entre el cuadrado y el texto
                          const Text(
                            'Oxigenación',
                            style: TextStyle(fontSize: 14), // Tamaño del texto
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: const [
                      Text(
                        '80 puntos',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(37, 17, 82, 1)),
                        textAlign: TextAlign.center, // Centra el texto
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

 Widget _buildEmotionColumn(String assetPath, String emotion) {
    bool isSelected = _selectedEmotion == emotion; // Verifica si es la emoción seleccionada
    return GestureDetector(
      onTap: () {
        _showEmotionDialog(context, emotion, assetPath); // Muestra el diálogo
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: const Color(0xFF9575CD), // Color del borde si está seleccionado
                      width: 3,
                    )
                  : null, // Sin borde si no está seleccionado
            ),
            child: Image.asset(
              assetPath,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            emotion,
            style: const TextStyle(
              color: Colors.white, // Color del texto
            ),
          ),
        ],
      ),
    );
  }

  void _showEmotionDialog(BuildContext context, String emotion, String assetPath) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: const Color.fromARGB(255, 41, 27, 73), // Color de fondo
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Hace que el dialog se ajuste al contenido
            children: [
              // Contenedor superior tipo píldora
              Container(
                width: 60, // Ancho de la píldora
                height: 8, // Altura de la píldora
                margin: const EdgeInsets.only(top: 1, bottom: 16), // Espaciado superior e inferior
                decoration: BoxDecoration(
                  color: const Color(0xFF9575CD), // Morado claro
                  borderRadius: BorderRadius.circular(30), // Forma redondeada
                ),
              ),
              // Texto del diálogo
              Text(
                'Se siente $emotion',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Color del texto en blanco
                ),
              ),
              const SizedBox(height: 20),
              // Imagen de la emoción
              Image.asset(
                assetPath,
                width: 75,
                height: 75,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 16),
              // Botones de Confirmar y Cancelar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedEmotion = emotion; // Establece la emoción seleccionada
                      });
                      Navigator.pop(context); // Cierra el diálogo
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 41, 27, 73), // Fondo
                      side: const BorderSide(
                        color: Color(0xFF9575CD), // Bordes morado claro
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Forma de píldora
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15, // Altura del botón
                        horizontal: 30,
                      ),
                    ),
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(color: Color(0xFF9575CD), fontSize: 18), // Texto en blanco
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cierra el diálogo
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 41, 27, 73), // Fondo
                      side: const BorderSide(
                        color: Color(0xFF9575CD), // Bordes morado claro
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Forma de píldora
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15, // Altura del botón
                        horizontal: 30,
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Color(0xFF9575CD), fontSize: 18), // Texto en blanco
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  

  
}
