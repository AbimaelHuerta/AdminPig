import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:porquiad/assets/classes/info.dart';

class CardInfoCria extends StatefulWidget {
  const CardInfoCria({super.key});

  @override
  State<CardInfoCria> createState() => _CardInfoCriaState();
}

List<CriaData> criaDataList = [];
List<TextEditingController> _controllers = [];
List<Widget> _campoAdicionales = [];

String formatearFecha(DateTime fecha) {
  return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
}

// Calcula la diferencia de días entre la fecha de fertilización y la fecha actual

class _CardInfoCriaState extends State<CardInfoCria> {
  String fechaAct = '';
  @override
  void initState() {
    super.initState();
    _loadcriaData();
  }

  Future<void> _loadcriaData() async {
    criaDataList = await CriaData.cargarData();
    setState(() {});
  }

  void actualizarDatos(CriaData cria, DateTime nuevaFechaInicio) async {
    setState(() {
      cria.inicioCalor = nuevaFechaInicio; // Actualiza la fecha en la lista
    });

    // Serializa la lista actualizada y sobrescribe el archivo JSON
    List jsonData = criaDataList.map((data) => data.toJson()).toList();

    try {
      final directorio = await getApplicationDocumentsDirectory();
      final file = File('${directorio.path}/data/data.json');

      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(jsonData));

      // print("Datos actualizados y guardados ");
    } catch (e) {
      // print("Error al guardar los datos $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Card(
        elevation: 5,
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Granja Huerta Pérez',
                        style: TextStyle(
                            fontSize: 23, fontFamily: 'Raleway_Medium'),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '"El hogar del mejor sabor porcino."',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lobster',
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'lib/assets/img/logo.png',
                    width: 90,
                    height: 100,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 10, // Espaciado horizontal entre columnas
                mainAxisSpacing: 10, // Espaciado vertical entre filas
                childAspectRatio: 4 / 7 // Relación de aspecto de cada tarjeta
                ),
            itemCount: criaDataList.length,
            itemBuilder: (BuildContext context, int index) {
              final cria = criaDataList[index];

              return Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Color(0xFFA8D5BA),
                      width: 1.5,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Hace que la tarjeta ocupe solo lo necesario
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'lib/assets/img/profile.png',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        '${cria.identificacion} (${cria.raza})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway_Medium',
                        ),
                      ),
                      const SizedBox(height: 5), // Espacio entre textos
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Fecha de inicio de calor:',
                            style: TextStyle(
                                fontSize: 12, fontFamily: 'Raleway_Light'),
                          ),
                          Text(
                            formatearFecha(cria.inicioCalor),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 0, 0),
                                fontFamily: 'Raleway'),
                          ),
                          const SizedBox(height: 5), // Espacio entre líneas
                          const Text(
                            'Próxima fertilización:',
                            style: TextStyle(
                                fontSize: 12, fontFamily: 'Raleway_Light'),
                          ),
                          Text(
                            formatearFecha(cria.calcularFecha(dias: 21)),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 0, 0),
                                fontFamily: 'Raleway'),
                          ),
                          ..._campoAdicionales,
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                DateTime nuevaFecha =
                                    cria.calcularFecha(dias: 21);
                                actualizarDatos(cria, nuevaFecha);

                                if (_campoAdicionales.isNotEmpty) {
                                  setState(() {
                                    _campoAdicionales.removeAt(index);
                                    _controllers.removeAt(index);
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(1),
                                  side: const BorderSide(
                                      color: Color(0xFFA8D5BA), width: 1)),
                              child: const Text('Reinicio',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Raleway_Medium',
                                      color: Colors.black))),
                          const SizedBox(
                            width: 5,
                          ),
                          OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  final dateCria =
                                      cria.calcularFecha(dias: 115);
                                  final nuevoController =
                                      TextEditingController();
                                  _controllers.add(nuevoController);

                                  _campoAdicionales.add(Column(
                                    children: [
                                      const Text(
                                        'Fecha a criar:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Raleway_Light'),
                                      ),
                                      Text(
                                        formatearFecha(dateCria),
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                            fontFamily: 'Raleway'),
                                      ),
                                    ],
                                  ));
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(1),
                                  side: const BorderSide(
                                      color: Color(0xFFA8D5BA), width: 1)),
                              child: const Text('Cria',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Raleway_Medium',
                                      color: Colors.black))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
    ]);
  }
}
