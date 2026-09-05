import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MiAppIngenieria());
}

class MiAppIngenieria extends StatelessWidget {
  const MiAppIngenieria({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herramientas de Ingeniería',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos DefaultTabController para manejar 3 pestañas
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Herramientas de Ingeniería de Procesos'),
          backgroundColor: Colors.blue[900],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            tabs: [
              Tab(icon: Icon(Icons.speed), text: 'Velocidad Tuberías'),
              Tab(icon: Icon(Icons.heat_pump), text: 'Volumen Intercambiador'),
              Tab(icon: Icon(Icons.water), text: 'Tablas de Vapor'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ModuloVelocidadTuberias(),
            ModuloVolumenIntercambiador(),
            ModuloTablasVapor(),
          ],
        ),
      ),
    );
  }
}

// ================= MODULE 1: VELOCIDAD EN TUBERÍAS =================
class ModuloVelocidadTuberias extends StatefulWidget {
  const ModuloVelocidadTuberias({super.key});

  @override
  State<ModuloVelocidadTuberias> createState() => _ModuloVelocidadTuberiasState();
}

class _ModuloVelocidadTuberiasState extends State<ModuloVelocidadTuberias> {
  final TextEditingController _flujoController = TextEditingController();
  final TextEditingController _diametroController = TextEditingController();
  String resultado = "Ingresa los datos para calcular la velocidad";

  void _calcularVelocidad() {
    double? gpm = double.tryParse(_flujoController.text);
    double? diametroIn = double.tryParse(_diametroController.text);

    if (gpm == null || diametroIn == null || diametroIn <= 0) {
      setState(() {
        resultado = "Por favor, ingresa valores numéricos válidos.";
      });
      return;
    }

    double caudalFt3s = gpm * 0.002228002;
    double diametroFt = diametroIn / 12.0;
    double radioFt = diametroFt / 2.0;
    double areaFt2 = pi * pow(radioFt, 2);
    double velocidadFtS = caudalFt3s / areaFt2;

    setState(() {
      resultado = "Velocidad calculada: ${velocidadFtS.toStringAsFixed(2)} ft/s";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Estimación de Velocidad de Agua en Tubería',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _flujoController,
            decoration: const InputDecoration(
              labelText: 'Flujo (GPM)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.water_drop),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _diametroController,
            decoration: const InputDecoration(
              labelText: 'Diámetro interno (pulgadas)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.circle_outlined),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calcularVelocidad,
            child: const Text('Calcular Velocidad'),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
            ),
            child: Text(
              resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MODULE 2: VOLUMEN DE INTERCAMBIADOR =================
class ModuloVolumenIntercambiador extends StatefulWidget {
  const ModuloVolumenIntercambiador({super.key});

  @override
  State<ModuloVolumenIntercambiador> createState() => _ModuloVolumenIntercambiadorState();
}

class _ModuloVolumenIntercambiadorState extends State<ModuloVolumenIntercambiador> {
  final TextEditingController _numTubosController = TextEditingController();
  final TextEditingController _diamTubosController = TextEditingController();
  final TextEditingController _longTubosController = TextEditingController();
  final TextEditingController _diamCarcazaController = TextEditingController();

  String resultadoVolumen = "Ingresa los datos del equipo";

  void _calcularVolumenes() {
    double? numTubos = double.tryParse(_numTubosController.text);
    double? diamTubosIn = double.tryParse(_diamTubosController.text);
    double? longitudFt = double.tryParse(_longTubosController.text);
    double? diamCarcazaIn = double.tryParse(_diamCarcazaController.text);

    if (numTubos == null || diamTubosIn == null || longitudFt == null || diamCarcazaIn == null) {
      setState(() {
        resultadoVolumen = "Por favor, completa todos los campos correctamente.";
      });
      return;
    }

    double radioTuboFt = (diamTubosIn / 12.0) / 2.0;
    double areaUnTubo = pi * pow(radioTuboFt, 2);
    double volumenUnTuboFt3 = areaUnTubo * longitudFt;
    double volumenTotalTubosFt3 = volumenUnTuboFt3 * numTubos;
    double volumenTotalTubosGal = volumenTotalTubosFt3 * 7.48052;

    double radioCarcazaFt = (diamCarcazaIn / 12.0) / 2.0;
    double areaCarcazaFt2 = pi * pow(radioCarcazaFt, 2);
    double volumenBrutoCarcazaFt3 = areaCarcazaFt2 * longitudFt;
    
    double volumenNetoCarcazaFt3 = volumenBrutoCarcazaFt3 - volumenTotalTubosFt3;
    if (volumenNetoCarcazaFt3 < 0) volumenNetoCarcazaFt3 = 0;
    double volumenNetoCarcazaGal = volumenNetoCarcazaFt3 * 7.48052;

    setState(() {
      resultadoVolumen = 
          "Lado Tubos:\n"
          "• ${volumenTotalTubosFt3.toStringAsFixed(2)} ft³ (${volumenTotalTubosGal.toStringAsFixed(1)} Gal)\n\n"
          "Lado Carcaza (Efectivo):\n"
          "• ${volumenNetoCarcazaFt3.toStringAsFixed(2)} ft³ (${volumenNetoCarcazaGal.toStringAsFixed(1)} Gal)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cálculo de Inventario / Volúmenes en Intercambiador',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _numTubosController,
            decoration: const InputDecoration(
              labelText: 'Número de tubos',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.format_list_numbered),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _diamTubosController,
            decoration: const InputDecoration(
              labelText: 'Diámetro interno del tubo (pulgadas)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.straighten),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _longTubosController,
            decoration: const InputDecoration(
              labelText: 'Longitud de los tubos (pies)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.swap_horiz),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _diamCarcazaController,
            decoration: const InputDecoration(
              labelText: 'Diámetro interno de la carcaza (pulgadas)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.radio_button_checked),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calcularVolumenes,
            child: const Text('Calcular Volúmenes'),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
            ),
            child: Text(
              resultadoVolumen,
              style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MODULE 3: TABLAS DE VAPOR =================
class ModuloTablasVapor extends StatefulWidget {
  const ModuloTablasVapor({super.key});

  @override
  State<ModuloTablasVapor> createState() => _ModuloTablasVaporState();
}

class _ModuloTablasVaporState extends State<ModuloTablasVapor> {
  final TextEditingController _presionController = TextEditingController();
  final TextEditingController _temperaturaController = TextEditingController();
  String resultadoVapor = "Ingrese Presión y Temperatura para evaluar estado";

  // Tabla de saturación simplificada de prueba [Presión psia, Temp_sat °F, hf (Btu/lb), hg (Btu/lb)]
  final List<Map<String, double>> tablaSaturacion = [
    {'P': 14.696, 'T': 212.0, 'hf': 180.16, 'hg': 1150.4},
    {'P': 50.0,   'T': 281.0, 'hf': 250.11, 'hg': 1174.1},
    {'P': 100.0,  'T': 327.8, 'hf': 298.40, 'hg': 1188.3},
    {'P': 200.0,  'T': 381.8, 'hf': 355.59, 'hg': 1201.5},
    {'P': 300.0,  'T': 417.3, 'hf': 394.00, 'hg': 1208.5},
  ];

  void _consultarEstadoVapor() {
    double? pInput = double.tryParse(_presionController.text);
    double? tInput = double.tryParse(_temperaturaController.text);

    if (pInput == null || tInput == null) {
      setState(() {
        resultadoVapor = "Por favor, ingresa valores numéricos válidos.";
      });
      return;
    }

    // Buscamos una aproximación en la tabla de saturación según la presión ingresada
    Map<String, double>? puntoCercano;
    double menorDiferencia = double.infinity;

    for (var punto in tablaSaturacion) {
      double diff = (punto['P']! - pInput).abs();
      if (diff < menorDiferencia) {
        menorDiferencia = diff;
        puntoCercano = punto;
      }
    }

    if (puntoCercano != null) {
      double tSat = puntoCercano['T']!;
      String estado = "";

      // Criterio básico de estado termodinámico comparando con la temperatura de saturación
      if ((tInput - tSat).abs() < 1.0) {
        estado = "Vapor Saturado";
      } else if (tInput < tSat) {
        estado = "Líquido Comprimido / Subenfriado";
      } else {
        estado = "Vapor Sobrecalentado";
      }

      setState(() {
        resultadoVapor = 
            "Estado Termodinámico: $estado\n\n"
            "• Presión evaluada: $pInput psia\n"
            "• Temperatura ingresada: $tInput °F\n"
            "• Temp. de Saturación teórica: ${tSat.toStringAsFixed(1)} °F\n"
            "• Entalpía líquido (hf): ${puntoCercano!['hf']} Btu/lb\n"
            "• Entalpía vapor (hg): ${puntoCercano['hg']} Btu/lb";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Determinación de Estado Termodinámico (Agua)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          const Text(
            'Ingrese la presión y temperatura de operación para verificar si el agua se encuentra en fase líquida, saturada o sobrecalentada.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _presionController,
            decoration: const InputDecoration(
              labelText: 'Presión (psia)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.compress),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _temperaturaController,
            decoration: const InputDecoration(
              labelText: 'Temperatura (°F)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.thermostat),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _consultarEstadoVapor,
            child: const Text('Consultar Estado de Vapor'),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
            ),
            child: Text(
              resultadoVapor,
              style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}