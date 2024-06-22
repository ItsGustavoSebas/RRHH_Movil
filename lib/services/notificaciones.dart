import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/notificaciones.dart';
import 'package:rrhh_movil/services/server.dart';
class NotificacionesService extends ChangeNotifier {
  late List<Notificaciones> notificaciones = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Notificaciones>> loadNotificaciones(String userId) async {
    isLoading = true;

    notificaciones = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/notificacion/getnotificaciones/$userId'));
        
        final List<dynamic> notificacionesMap = json.decode(resp.body);


      notificacionesMap.forEach((element) {
      final map = Notificaciones.fromMap(element);
      notificaciones.add(map);
    });

    isLoading = false;
    notifyListeners();
    return notificaciones;
  }

  Future<String> marcarTodasComoLeidas(String userId) async {
    final uri = Uri.parse('${servidor.baseUrl}/notificacion/marcartodas/$userId');
    final response = await http.post(uri);
    if (response.statusCode == 200) {
      return 'hecho';
    } else {
      return 'error';
    }
  }

  Future<String> marcarComoLeida(String userId, String notificacionId) async {
    final uri = Uri.parse('${servidor.baseUrl}/notificacion/marcar/$userId/$notificacionId');
    final response = await http.post(uri);
    if (response.statusCode == 200) {
      return 'hecho';
    } else {
      return 'error';
    }
  }
}
