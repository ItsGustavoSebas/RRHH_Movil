import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/nivelidiomas.dart';
import 'package:rrhh_movil/models/puestodisponible.dart';
import 'package:rrhh_movil/services/services.dart';

class NivelIdiomasService extends ChangeNotifier {
  late List<Nivelidiomas> nivelIdiomas = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Nivelidiomas>> loadNivelIdiomas() async {
    isLoading = true;

    nivelIdiomas = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/postulantes/nivelIdiomas'));
        
        final List<dynamic> nivelIdiomasMap = json.decode(resp.body);


      nivelIdiomasMap.forEach((element) {
      final map = Nivelidiomas.fromMap(element);
      nivelIdiomas.add(map);
    });

    isLoading = false;
    notifyListeners();
    return nivelIdiomas;
  }

}
