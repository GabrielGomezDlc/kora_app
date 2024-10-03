import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kora_app/ui/iam/login.dart';  // Importa Login desde su archivo

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de que los widgets están inicializados
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kora App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: false,
      ),
      home: const Login(),  // La primera pantalla será la de Login
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kora_app/ui/home/home.dart';
import 'package:kora_app/ui/iam/login.dart';
import 'package:kora_app/ui/personalized_techniques/breathing_exercises.dart';
import 'package:kora_app/ui/personalized_techniques/musictherapy.dart';
import 'package:kora_app/ui/questionary/stai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de que los widgets están inicializados
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kora App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: false,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Login(), 
    Home(),
    Stai(),          // Tu vista de Home
    BreathingExercises(), // Vista placeholder para estadísticas
    Musictherapy(),   // Vista placeholder para favoritos
    Text('Descargas'),   // Vista placeholder para descargas
    Text('Perfil'),      // Vista placeholder para perfil
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
          size: 24,  // Tamaño de los íconos
          color: isSelected ?const Color(0xFF4D24AF) : Colors.grey,
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),  // Espacio entre el ícono y el puntito
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Mantiene todas las opciones visibles
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIconWithIndicator(
              iconData: Icons.home_filled,
              isSelected: _selectedIndex == 0,
            ),
            label: '', // Oculta la etiqueta
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
        selectedItemColor: Color(0xFF4D24AF), // Color del ícono seleccionado
        unselectedItemColor: Colors.grey, // Color de íconos no seleccionados
        showSelectedLabels: false,  // Oculta las etiquetas
        showUnselectedLabels: false,  // Oculta las etiquetas
      ),
    );
  }
}*/
