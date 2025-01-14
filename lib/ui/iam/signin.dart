import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kora_app/data/model/Auth/login_status.dart';
import 'package:kora_app/data/remote/KoraAPI/kora_http_helper.dart';
import 'package:kora_app/main.dart';
import 'package:kora_app/styles/colors.dart';
import 'package:kora_app/styles/texts.dart';
import 'package:kora_app/ui/biometric_recollection/sleep_hours.dart';
import 'package:kora_app/ui/connect_smartwatch_tuto/smartwatch_setup.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:kora_app/ui/data_collection_method/data_collection_method.dart';
import 'package:kora_app/ui/iam/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  String? displayName;
  String? email;
  String? photoURL;

  String? selectedGender;
  int selectedAge = 18;

  String? selectedOperation;
  final List<String> operations = [
    "Cirugía de Bypass",
    "Reemplazo de válvula",
    "Reparación de válvula",
    "Cirugía de corazón abierto",
    "Implante de marcapasos"
  ];

  DateTime? selectedDate;

  bool agreePrivacyPolicy = false;
  bool agreeTermsOfUse = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _changeTutoConnectionStatus();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName');
      email = prefs.getString('email');
      photoURL = prefs.getString('photoURL');
    });
  }

  Future<void> _changeTutoConnectionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tutoSWConnectPassed', "false");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7654E7),
              Color(0xFF241152),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage: photoURL != null
                                  ? NetworkImage(photoURL!)
                                  : null,
                              radius: 40,
                              child: photoURL == null
                                  ? const Icon(Icons.person, size: 30)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        email ?? 'Correo no disponible',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Hola, ${displayName ?? 'Usuario'}",
                style: const TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),
              Container(
                width: 50,
                child: const Divider(
                  color: AppColors.secondaryColor,
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("¿Cuál es tu género? ",
                      style: AppTextStyles.headline2),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGenderButton("Masculino"),
                      const SizedBox(width: 20),
                      _buildGenderButton("Femenino"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("¿Cuál es tu edad? ",
                      style: AppTextStyles.headline2),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 100,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 50,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedAge =
                              index + 18; // Actualizar el índice seleccionado
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) => Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (index + 18 == selectedAge)
                                  ? AppColors
                                      .secondaryColor // Fondo destacado si está seleccionado
                                  : Colors
                                      .transparent, // Fondo transparente si no está seleccionado
                              border: Border.all(
                                color:
                                    AppColors.secondaryColor, // Color del borde
                                width: 2, // Grosor del borde
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${index + 18}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: (index + 18 == selectedAge)
                                      ? Colors
                                          .white // Texto blanco si está seleccionado
                                      : AppColors
                                          .secondaryColor, // Texto secundario si no está seleccionado
                                ),
                              ),
                            ),
                          ),
                        ),
                        childCount: 63,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "¿Cuál es tu tipo de operación? ",
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.secondaryColor, // Color del borde
                        width: 2, // Grosor del borde
                      ),
                      borderRadius:
                          BorderRadius.circular(10), // Bordes redondeados
                      color: Colors.transparent, // Fondo transparente
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedOperation,
                        hint: const Text(
                          "Selecciona una operación",
                          style: TextStyle(
                            color: AppColors
                                .secondaryColor, // Color del texto inicial
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        alignment: Alignment
                            .centerLeft, // Alinea el texto correctamente
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.secondaryColor, // Color del icono
                        ),
                        isExpanded: true, // Ocupa todo el ancho disponible
                        borderRadius: BorderRadius.circular(
                            10), // Esquinas redondeadas al desplegar
                        dropdownColor: Colors
                            .white, // Fondo blanco en el dropdown desplegado
                        selectedItemBuilder: (BuildContext context) {
                          return operations.map((String operation) {
                            return Center(
                              child: Text(
                                operation,
                                style: const TextStyle(
                                  color: AppColors
                                      .secondaryColor, // Color de la opción seleccionada
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        items: operations.map((String operation) {
                          return DropdownMenuItem<String>(
                            value: operation,
                            child: Text(
                              operation,
                              style: const TextStyle(
                                color: AppColors
                                    .primaryColor, // Color de las opciones desplegadas
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOperation =
                                newValue; // Actualiza la selección
                          });
                        },
                        menuMaxHeight:
                            200, // Altura máxima del menú (aproximadamente 5 elementos)
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Indica la fecha de tu operación: ",
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      // Mostrar el selector de fecha
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), // Fecha inicial
                        firstDate: DateTime(2000), // Fecha mínima
                        lastDate: DateTime(2100), // Fecha máxima
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors
                                    .secondaryColor, // Color del encabezado
                                onPrimary: Colors
                                    .white, // Color del texto del encabezado
                                onSurface:
                                    AppColors.primaryColor, // Color del texto
                              ),
                              dialogBackgroundColor:
                                  Colors.white, // Fondo del DatePicker
                            ),
                            child: child!,
                          );
                        },
                      );

                      // Actualizar la fecha seleccionada
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate; // Actualizar el estado
                        });
                      }
                    },
                    child: SizedBox(
                      width: double
                          .infinity, // Asegura que ocupe todo el ancho disponible
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.secondaryColor, // Color del borde
                            width: 2, // Grosor del borde
                          ),
                          borderRadius:
                              BorderRadius.circular(10), // Bordes redondeados
                          color: Colors.transparent, // Fondo transparente
                        ),
                        child: Center(
                          child: Text(
                            selectedDate != null
                                ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}" // Formato de la fecha seleccionada
                                : "Selecciona una fecha",
                            textAlign: TextAlign
                                .center, // Centra el texto horizontalmente
                            style: const TextStyle(
                              color:
                                  AppColors.secondaryColor, // Color del texto
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              // Botón "Continuar"
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (selectedGender == null) {
                      // Mostrar advertencia si el género no está seleccionado
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Por favor, selecciona tu género.",
                              style: TextStyle(
                                  fontSize: 18, color: AppColors.primaryColor)),
                          backgroundColor: AppColors.secondaryColor,
                        ),
                      );
                      return;
                    }

                    if (selectedOperation == null) {
                      // Mostrar advertencia si el tipo de operación no está seleccionado
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Por favor, selecciona tu tipo de operación.",
                              style: TextStyle(
                                  fontSize: 18, color: AppColors.primaryColor)),
                          backgroundColor: AppColors.secondaryColor,
                        ),
                      );
                      return;
                    }

                    if (selectedDate == null) {
                      // Mostrar advertencia si la fecha no está seleccionada
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Por favor, selecciona la fecha de tu operación.",
                              style: TextStyle(
                                  fontSize: 18, color: AppColors.primaryColor)),
                          backgroundColor: AppColors.secondaryColor,
                        ),
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Bordes redondeados
                              ),
                              backgroundColor:
                                  AppColors.primaryColor, // Fondo morado claro
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Primera Checkbox con texto
                                  Row(
                                    children: [
                                      Checkbox(
                                        value:
                                            agreePrivacyPolicy, // Variable de estado
                                        onChanged: (bool? value) {
                                          setState(() {
                                            agreePrivacyPolicy = value ?? false;
                                          });
                                        },
                                        activeColor: AppColors
                                            .secondaryColor, // Color del checkbox activo
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors
                                                  .white, // Color general del texto
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Acepto la "),
                                              TextSpan(
                                                text: "Política de privacidad",
                                                style: TextStyle(
                                                  color:
                                                      AppColors.secondaryColor,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        print(
                                                            'Privacy Policy tapped');
                                                        // Acción al presionar
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Segunda Checkbox con texto
                                  Row(
                                    children: [
                                      Checkbox(
                                        value:
                                            agreeTermsOfUse, // Variable de estado
                                        onChanged: (bool? value) {
                                          setState(() {
                                            agreeTermsOfUse = value ?? false;
                                          });
                                        },
                                        activeColor: AppColors
                                            .secondaryColor, // Color del checkbox activo
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors
                                                  .white, // Color general del texto
                                            ),
                                            children: [
                                              const TextSpan(
                                                  text: "Acepto los "),
                                              TextSpan(
                                                text: "Terminos de uso",
                                                style: TextStyle(
                                                  color:
                                                      AppColors.secondaryColor,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        print(
                                                            'Terms of Use tapped');
                                                        // Acción al presionar
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Texto de advertencia
                                  const Text(
                                    "Solo puedes avanzar si estás de acuerdo con todo lo anterior.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey, // Color gris claro
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // Botón de Log In
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: agreePrivacyPolicy &&
                                              agreeTermsOfUse
                                          ? () async {
                                              // Mostrar un indicador de carga mientras se realiza la operación
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                },
                                              );

                                              try {
                                                final koraHelper = KoraHelper();

                                                final LogInStatus status =
                                                    await koraHelper.signIn(
                                                  displayName ??
                                                      '', // Nombre completo
                                                  email ?? '', // Email
                                                  photoURL ??
                                                      '', // Foto de perfil
                                                  selectedAge, // Edad seleccionada
                                                  selectedGender ??
                                                      '', // Género seleccionado
                                                  selectedOperation ??
                                                      '', // Tipo de operación seleccionada
                                                  "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}", // Fecha seleccionada
                                                );

                                                Navigator.pop(
                                                    context); // Cierra el indicador de carga

                                                if (status ==
                                                    LogInStatus.userloged) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DataCollectionMethodScreen()), // Ajusta la pantalla
                                                  );
                                                }
                                              } catch (e) {
                                                Navigator.pop(
                                                    context); // Cierra el indicador de car
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Error al registrar la cuenta: $e'),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 246, 81, 69),
                                                  ),
                                                );
                                              }
                                            }
                                          : null, // Desactiva el botón si no están ambas opciones marcadas
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors
                                            .secondaryColor, // Fondo del botón
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              30), // Bordes redondeados
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                      ),
                                      child: const Text(
                                        "Confirmar",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Registrarme",
                          style: TextStyle(
                            color: Color(0xFF241152),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Pregunta de inicio de sesión
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿Ya te has registrado? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: const Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Botón de selección de género
  Widget _buildGenderButton(String gender) {
    final bool isSelected = selectedGender == gender;

    // Asignar ícono según el género
    final IconData genderIcon =
        gender == "Masculino" ? Icons.male : Icons.female;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: 160, // Botón ocupa todo el ancho disponible
        decoration: BoxDecoration(
          color: const Color(0xFF7654E7),
          border: Border.all(
            color: isSelected
                ? AppColors.secondaryColor
                : const Color.fromARGB(56, 211, 211, 211),
            width: 2, // Grosor del borde
          ),
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Icono y texto alineados a la izquierda
          children: [
            Icon(
              genderIcon,
              color: isSelected
                  ? AppColors.secondaryColor
                  : const Color.fromARGB(139, 211, 211, 211),
            ),
            const SizedBox(width: 10), // Espaciado entre ícono y texto
            Text(
              gender,
              style: TextStyle(
                  color: isSelected
                      ? AppColors.secondaryColor
                      : const Color.fromARGB(139, 211, 211, 211),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
