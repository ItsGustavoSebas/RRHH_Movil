import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/fuentedecontratacion.dart';
import 'package:rrhh_movil/services/services.dart';

class FuenteDeContratacionService extends ChangeNotifier {
  late List<Fuentedecontratacion> fuentesDeContratacion = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Fuentedecontratacion>> loadFuentesDeContratacion() async {
    isLoading = true;

    fuentesDeContratacion = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/postulantes/fuenteDeContratacion'));
        
        final List<dynamic> fuentesDeContratacionMap = json.decode(resp.body);


      fuentesDeContratacionMap.forEach((element) {
      final map = Fuentedecontratacion.fromMap(element);
      fuentesDeContratacion.add(map);
    });

    isLoading = false;
    notifyListeners();
    return fuentesDeContratacion;
  }

}
