import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:porquiad/assets/classes/info.dart';

class NotificationService {
  // Singleton para el servicio de notificaciones
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Icono predeterminado

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Método para mostrar notificación instantánea
  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: false);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void _showNotification(String body) {
    NotificationService().showNotification(
        id: 0, title: 'PROXIMA A ENTRAR EN CALOR', body: body);
  }

  void verificarFertilizacion(List<CriaData> crias) {
    for (var cria in crias) {
      DateTime proximaFertilizacion = cria.calcularFecha(dias: 21);

      int diasRestantes =
          NotificationService().calcularDiasRestantes(proximaFertilizacion);
      print(diasRestantes);

      if (diasRestantes <= 7 && diasRestantes >= 2) {
        _showNotification(
            '${cria.identificacion} está a $diasRestantes días de fertilización');
      }
    }
  }

  int calcularDiasRestantes(DateTime fechaFertilizacion) {
    final DateTime fechaActual = DateTime.now();
    final Duration diferencia = fechaFertilizacion.difference(fechaActual);

    return diferencia.inDays; // Obtiene los días restantes
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  void onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      List<CriaData> crias = await CriaData.cargarData();
      verificarFertilizacion(crias);
    });
  }
}
