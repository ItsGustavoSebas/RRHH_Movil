import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class ReconocimientosService extends ChangeNotifier {
  late List<Reconocimientos> reconocimientos = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Reconocimientos>> loadReconocimientos(String userId) async {
    isLoading = true;

    reconocimientos = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/postulante/reconocimientos/$userId'));

     final List<dynamic> reconocimientosMap = json.decode(resp.body);

      reconocimientosMap.forEach((element) {
      final map = Reconocimientos.fromMap(element);
      reconocimientos.add(map);
    });

    isLoading = false;
    notifyListeners();
    return reconocimientos;
  }

}
