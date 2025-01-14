import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:kora_app/styles/colors.dart';
import 'package:kora_app/styles/texts.dart';
import 'package:kora_app/ui/biometric_recollection/sleep_hours.dart';
import 'package:kora_app/ui/connect_smartwatch_tuto/smartwatch_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCollectionMethodScreen extends StatefulWidget {
  const DataCollectionMethodScreen({Key? key}) : super(key: key);

  @override
  _DataCollectionMethodScreenState createState() =>
      _DataCollectionMethodScreenState();
}

class _DataCollectionMethodScreenState
    extends State<DataCollectionMethodScreen> {
  String selectedMethod = ''; // Variable para gestionar el botón seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Espaciado superior
              const Spacer(flex: 2),
              // Títulos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¿Cómo quieres que recolectemos tus datos de salud?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Los datos a utilizar son ',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Ritmo Cardíaco',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ', ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Horas de Sueño ',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'y ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Oxigenación en la Sangre.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Espaciado entre títulos y botones
              // Botones en fila
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptionButton(
                    label: 'Manual',
                    description: 'Ingresará los datos \nmanualmente.',
                    icon: Icons.edit_note,
                    selected: selectedMethod == 'manual',
                    onTap: () => setState(() {
                      selectedMethod = 'manual';
                    }),
                  ),
                  const SizedBox(width: 20), // Espaciado entre botones
                  _buildOptionButton(
                    label: 'Smartwatch',
                    description: 'Recolección automática\ncon smartwatch.',
                    icon: Icons.watch,
                    selected: selectedMethod == 'smartwatch',
                    onTap: () => setState(() {
                      selectedMethod = 'smartwatch';
                    }),
                    infoCallback: () => _showSmartwatchInfoDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espaciado entre cards y texto
              // Texto con ícono
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.secondaryColor,
                    size: 16, // Tamaño del ícono ajustado
                  ),
                  const SizedBox(
                      width: 5), // Separación entre el ícono y el texto
                  Text(
                    'Compatible únicamente con smartwatches Samsung.',
                    style: TextStyle(
                      fontSize: 16, // Tamaño de texto más grande
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(
                  flex:
                      2), // Espaciado entre texto e ícono y el botón Confirmar
              // Botón Confirmar
              SizedBox(
                width: double.infinity, // Ocupa todo el ancho disponible
                child: ElevatedButton(
                  onPressed: selectedMethod.isNotEmpty
                      ? () async {
                          if (selectedMethod == 'smartwatch') {
                            await _saveSelectedMethod(selectedMethod);
                            final hasHealthConnect =
                                await isHealthConnectInstalled();
                            if (!hasHealthConnect) {
                              _showInstallHealthConnectDialog(context);
                            } else {
                              await requestHealthConnectPermissions();
                            }

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SmartwatchSetupView()),
                            );
                          } else {
                            await _saveSelectedMethod(selectedMethod);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SleepTrackingView()),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(flex: 1), // Espaciado inferior
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveSelectedMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedMethod', method);
    print("Método seleccionado guardado: $method");
  }

  Future<void> requestHealthConnectPermissions() async {
    // configure the health plugin before use.
    Health().configure();

    List<HealthDataType> types = [
      HealthDataType.SLEEP_SESSION,
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_OXYGEN,
    ];

    bool requested = await Health().requestAuthorization(types);

    if (requested) {
      print("Permisos otorgados.");
    } else {
      print(
          "Permisos denegados. Por favor, permite el acceso en Health Connect.");
    }
  }

  Widget _buildOptionButton({
    required String label,
    required String description,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    VoidCallback? infoCallback,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 220,
            width: 150,
            decoration: BoxDecoration(
              color: selected ? AppColors.secondaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.secondaryColor,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 70,
                  color: selected ? Colors.white : AppColors.secondaryColor,
                ),
                const SizedBox(height: 25),
                Text(
                  label,
                  style: AppTextStyles.headline2.copyWith(
                    color: selected ? Colors.white : AppColors.secondaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: selected ? Colors.white70 : Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          if (infoCallback != null)
            Positioned(
              top: -5,
              right: -5,
              child: IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: selected ? Colors.white : AppColors.secondaryColor,
                  size: 20,
                ),
                onPressed: infoCallback,
              ),
            ),
        ],
      ),
    );
  }

  void _showSmartwatchInfoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: AppColors.dialogBackgroundColor, // Color de fondo
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
            children: [
              // Contenedor superior tipo píldora
              Container(
                width: 60, // Ancho de la píldora
                height: 8, // Altura de la píldora
                margin: const EdgeInsets.only(top: 1, bottom: 16), // Espaciado
                decoration: BoxDecoration(
                  color: AppColors.tercearyColor, // Color morado claro
                  borderRadius: BorderRadius.circular(30), // Forma redondeada
                ),
              ),
              // Título principal
              Text(
                'Recopilación con Smartwatch',
                style: AppTextStyles.dialogHeadline1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Descripción
              const Text(
                'Para poder recopilar sus datos de salud, se utilizará la aplicación Health Connect.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Logo de Health Connect
              Image.asset(
                'assets/health_connect_logo.png', // Ruta del logo de Health Connect
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              // Botón de Comprendo
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dialogBackgroundColor, // Fondo
                  side: const BorderSide(
                    color: AppColors.tercearyColor, // Bordes morado claro
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Forma redondeada
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15, // Altura del botón
                    horizontal: 30,
                  ),
                ),
                child: const Text(
                  'Comprendo',
                  style: AppTextStyles.dialogButton, // Estilo del texto
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInstallHealthConnectDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: AppColors.dialogBackgroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 8,
                margin: const EdgeInsets.only(top: 1, bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.tercearyColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const Text(
                'Aplicación Necesaria',
                style: AppTextStyles.dialogHeadline1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Para poder recopilar sus datos de salud, es necesario que descargue la aplicación Health Connect.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/health_connect_logo.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await Health().installHealthConnect();
                  Navigator.pop(context); // Cierra el diálogo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dialogBackgroundColor,
                  side: const BorderSide(
                    color: AppColors.tercearyColor,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                ),
                child: const Text(
                  'Instalar',
                  style: AppTextStyles.dialogButton,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> isHealthConnectInstalled() async {
    assert(Platform.isAndroid, "This is only available on Android");

    final status = await Health().getHealthConnectSdkStatus();
    return status?.name.toUpperCase() != "SDKUNAVAILABLEPROVIDERUPDATEREQUIRED";
  }
}
