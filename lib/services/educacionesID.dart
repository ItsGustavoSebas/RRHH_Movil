import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class EducacionesIDService extends ChangeNotifier {
  late List<Educaciones> educacionesID = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Educaciones>> loadEducacionesID(String id) async {
    isLoading = true;

    educacionesID = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/educacionesID/$id'));

     final List<dynamic> educacionesMap = json.decode(resp.body);

      educacionesMap.forEach((element) {
      final map = Educaciones.fromMap(element);
      educacionesID.add(map);
    });

    isLoading = false;
    notifyListeners();
    return educacionesID;
  }

}
