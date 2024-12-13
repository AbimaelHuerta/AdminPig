import 'package:flutter/material.dart';

class FormsModal extends StatefulWidget {
  const FormsModal({super.key});

  @override
  _FormsModalState createState() => _FormsModalState();
}

class _FormsModalState extends State<FormsModal> {
  
  final TextEditingController _dateController = TextEditingController();
 
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
