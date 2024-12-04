

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormsModal extends StatefulWidget {
  const FormsModal({super.key});

  @override
  _FormsModalState createState() => _FormsModalState();
}

class _FormsModalState extends State<FormsModal> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _criasController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _identificacionController =
      TextEditingController();
  DateTime? _selectedDate;
  

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Obtener el tamaño del teclado 
    final bottomInswrs = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomInswrs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              'Agregar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _identificacionController,
                  decoration: const InputDecoration(labelText: 'Identificación'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _razaController,
                  decoration: const InputDecoration(labelText: 'Raza'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _criasController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Crias'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Inicio de calor',
                  hintText: _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : 'Seleccionar fecha',
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (){

            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              backgroundColor: Colors.pink.shade200,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
      ),
    );
  }
}
