import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/puestodisponible.dart';
import 'package:rrhh_movil/services/services.dart';

class PuestoDisponibleService extends ChangeNotifier {
  late List<Puestodisponible> puestosDisponible = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<Puestodisponible>> loadPuestosDisponible() async {
    isLoading = true;

    puestosDisponible = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/postulantes/puestoDisponible'));
        
        final List<dynamic> puestosDisponibleMap = json.decode(resp.body);


      puestosDisponibleMap.forEach((element) {
      final map = Puestodisponible.fromMap(element);
      puestosDisponible.add(map);
    });

    isLoading = false;
    notifyListeners();
    return puestosDisponible;
  }

}
