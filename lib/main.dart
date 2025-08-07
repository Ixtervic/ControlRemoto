import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 7, 255, 251),
          secondary: Colors.white70,
          tertiary: Color.fromARGB(255, 188, 191, 191),
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

    final double luzExterior = (350 - ambientLightIntensity).clamp(0, 350);

    final double porcentajeFoco = (ambientLightIntensity > 200)
        ? ((ambientLightIntensity - 200) / 150 * 100).clamp(0, 100)
        : 0;

    final bool focoEncendido = porcentajeFoco > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Automático'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 7, 255, 251),
      ),
      body: Center(
        child: Container(
          width: 360,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF1A1A2E),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LumiControl',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Sistema de Iluminación Inteligente',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Column(
                  children: [
                    Text(
                      'Luz Exterior Detectada',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey.shade200,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${luzExterior.round()}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 7, 255, 251),
                      ),
                    ),
                    Text(
                      'de 350',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: focoEncendido
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: focoEncendido
                        ? Colors.cyanAccent
                        : Colors.white10,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      focoEncendido ? Icons.lightbulb : Icons.lightbulb_outline,
                      size: 48,
                      color: focoEncendido
                          ? const Color.fromARGB(255, 7, 255, 251)
                          : Colors.white30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      focoEncendido ? 'Foco Encendido al:' : 'Foco Apagado',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    if (focoEncendido)
                      Text(
                        '${porcentajeFoco.round()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 7, 255, 251),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
