import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class ReferenciasService extends ChangeNotifier {
  late List<Referencias> referencias = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Referencias>> loadReferencias(String userId) async {
    isLoading = true;

    referencias = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/postulante/referencias/$userId'));

     final List<dynamic> referenciasMap = json.decode(resp.body);

      referenciasMap.forEach((element) {
      final map = Referencias.fromMap(element);
      referencias.add(map);
    });

    isLoading = false;
    notifyListeners();
    return referencias;
  }

}
