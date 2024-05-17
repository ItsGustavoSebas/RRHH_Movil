import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class EducacionesService extends ChangeNotifier {
  late List<Educaciones> educaciones = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Educaciones>> loadEducaciones(String userId) async {
    isLoading = true;

    educaciones = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/postulante/educaciones/$userId'));

     final List<dynamic> educacionesMap = json.decode(resp.body);

      educacionesMap.forEach((element) {
      final map = Educaciones.fromMap(element);
      educaciones.add(map);
    });

    isLoading = false;
    notifyListeners();
    return educaciones;
  }

}
