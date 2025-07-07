import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Remoto',
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
  bool isLightOn = true;
  bool isManualMode = true;
  double intensity = 47.0;
  double ambientLight = 56.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Remoto'),
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
              Text('Control Remoto',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary)),
              const SizedBox(height: 4),
              Text('Control de Iluminación Inteligente',
                  style: TextStyle(
                      fontSize: 14, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 20),
              IconButton(
                iconSize: 72,
                color: Colors.white,
                icon: Icon(isLightOn ? Icons.wb_sunny : Icons.lightbulb_outline),
                style: isLightOn ?
                  IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  elevation: 10,
                  shape: const CircleBorder(),
                  ) :
                  IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  elevation: 10,
                  shape: const CircleBorder(),),
                onPressed: () {
                  setState(() {
                    isLightOn = !isLightOn;
                  });
                },
              ),
              Text(
                isLightOn ? 'Encendido' : 'Apagado',
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.handshake),
                        Switch(
                          value: isManualMode,
                          onChanged: (value) {
                            setState(() {
                              isManualMode = value;
                            });
                          },
                          activeColor: theme.colorScheme.primary,
                        ),
                        const Icon(Icons.auto_mode_outlined),
                      ],
                    ),
                    Text('Modo: ${isManualMode ? 'Manual' : 'Automático'}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Intensidad',
                            style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface)),
                        Text('${intensity.round()}%',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary)),
                      ],
                    ),
                    Slider(
                      value: intensity,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: '${intensity.round()}%',
                      onChanged: (value) {
                        setState(() {
                          intensity = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                          color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    ),
                    Text(
                      '${ambientLight.round()}%',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary),
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
