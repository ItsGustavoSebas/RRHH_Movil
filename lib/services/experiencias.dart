import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class ExperienciasService extends ChangeNotifier {
  late List<Experiencias> experiencias = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Experiencias>> loadExperiencias(String userId) async {
    isLoading = true;

    experiencias = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/postulante/experiencias/$userId'));

     final List<dynamic> experienciasMap = json.decode(resp.body);

      experienciasMap.forEach((element) {
      final map = Experiencias.fromMap(element);
      experiencias.add(map);
    });

    isLoading = false;
    notifyListeners();
    return experiencias;
  }

}
