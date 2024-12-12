import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CriaData {
  String identificacion;
  String raza;
  String peso;
  String crias;
  DateTime inicioCalor;

  CriaData({
    required this.identificacion,
    required this.raza,
    required this.peso,
    required this.crias,
    required this.inicioCalor,
  });

  factory CriaData.fromJson(Map<String, dynamic> json) {
    return CriaData(
      identificacion: json['Identificacion'],
      raza: json['Raza'],
      peso: json['Peso'],
      crias: json['Crias'],
      inicioCalor:
          DateTime.parse(json['InicioCalor']),
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'Identificacion': identificacion,
      'Raza': raza,
      'Peso': peso,
      'Crias': crias,
      'InicioCalor': inicioCalor.toIso8601String(), // Formato ISO 8601 para fechas
    };
  }

  DateTime calcularFecha({int dias = 0, int semanas = 0, int meses = 0}) {
    return inicioCalor.add(Duration(days: dias + semanas * 7));
  }

  static Future<List<CriaData>> cargarData() async {
    try {
      final directorio = await getApplicationDocumentsDirectory();
      final file = File('${directorio.path}/data/data.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        return jsonData.map((json) => CriaData.fromJson(json)).toList();
        
      } else {
        final jsonString =
            await rootBundle.loadString('lib/assets/data/data.json');
        final List<dynamic> jsonData = jsonDecode(jsonString);

        return jsonData.map((json) => CriaData.fromJson(json)).toList();
      }
    } catch (e) {
      // print("Error al cargar los datos $e");
      return [];
    }

  }

}
