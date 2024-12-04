import 'package:flutter/material.dart';
import 'package:porquiad/widgets/card.dart';
import 'package:porquiad/services/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF5F5),
          toolbarHeight: 125.0,
          title: Row(
            children: [
              Image.asset(
                'lib/assets/img/profile.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenidos',
                    style:
                        TextStyle(fontSize: 30, fontFamily: 'Raleway_Medium'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Orilla Del Monte',
                    style: TextStyle(fontSize: 14, fontFamily: 'Raleway_Light'),
                  ),
                ],
              )
            ],
          ),
        ),
        body: const CardInfoCria(),
        backgroundColor: const Color(0xFFFFF5F5),
        // floatingActionButton: Builder(
        //   builder: (BuildContext context) {
        //     return FloatingActionButton(
        //       child: const Icon(Icons.add),
        //       onPressed: () => showModalBottomSheet(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return const FormsModal();
        //           }),
        //     );
        //   },
        // ),
      ),
    );
  }
}
