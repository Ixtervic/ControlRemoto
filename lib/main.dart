import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase usando firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Automático',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: const Color.fromARGB(255, 7, 255, 251),
          secondary: Colors.white70,
          tertiary: const Color.fromARGB(255, 188, 191, 191),
        ),
      ),
      home: const LumiControlHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LumiControlHomePage extends StatefulWidget {
  const LumiControlHomePage({super.key});

  @override
  State<LumiControlHomePage> createState() => _LumiControlHomePageState();
}

class _LumiControlHomePageState extends State<LumiControlHomePage> {
  double ambientLightIntensity = 0.0;

  late final DatabaseReference dbRef;

  /// Tiempo entre actualizaciones (en minutos)
  final int fetchIntervalMinutes = 1;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    _fetchData();
    _schedulePeriodicUpdates();
  }

  void _schedulePeriodicUpdates() {
    Timer.periodic(Duration(minutes: fetchIntervalMinutes), (timer) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final snapshot = await dbRef.child('lumiControl/ambientLight').get();

    if (snapshot.exists) {
      setState(() {
        ambientLightIntensity = (snapshot.value as num).toDouble();
      });
    } else {
      debugPrint('No se encontraron datos en /lumiControl/ambientLight');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Automático'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 360,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                'Control Automático',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Text(
                'Control de Iluminación Inteligente',
                style: TextStyle(
                    fontSize: 14, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 30),

              // Luz ambiente actual
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.cardColor.withOpacity(0.8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Luz Ambiente Actual',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '${ambientLightIntensity.round()}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
