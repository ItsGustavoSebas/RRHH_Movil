import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/idiomas.dart';
import 'package:rrhh_movil/services/services.dart';

class IdiomasService extends ChangeNotifier {
  late List<Idiomas> idiomas = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Idiomas>> loadIdiomas() async {
    isLoading = true;

    idiomas = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/postulantes/idiomas'));
        
        final List<dynamic> idiomasMap = json.decode(resp.body);


      idiomasMap.forEach((element) {
      final map = Idiomas.fromMap(element);
      idiomas.add(map);
    });

    isLoading = false;
    notifyListeners();
    return idiomas;
  }

}
