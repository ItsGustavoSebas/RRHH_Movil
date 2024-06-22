import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class PermisosService extends ChangeNotifier {
  late List<Permisos> permisos = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Permisos>> loadPermisos(String userId) async {
    isLoading = true;

    permisos = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/empleado/getPermisosEmpleado/$userId'));

     final List<dynamic> permisosMap = json.decode(resp.body);

      permisosMap.forEach((element) {
      final map = Permisos.fromMap(element);
      permisos.add(map);
    });

    isLoading = false;
    notifyListeners();
    return permisos;
  }

}
