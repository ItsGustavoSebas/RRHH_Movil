import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/puestodisponible.dart';
import 'package:rrhh_movil/services/server.dart';

class PuestosDisponiblesService extends ChangeNotifier {
  List<Puestodisponible> puestosDisponible = [];
  bool isLoading = true;
  final Servidor servidor = Servidor();

  Future<void> loadPuestosDisponible() async {
    isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('${servidor.baseUrl}/puestos/getpuestos'));

    final List<dynamic> puestosMap = json.decode(response.body);

    puestosDisponible = puestosMap.map((e) => Puestodisponible.fromMap(e)).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<String> postularse(String userId, String puestoId) async {
    final uri = Uri.parse('${servidor.baseUrl}/puestos/postularse/$userId/$puestoId');
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return 'hecho';
    } else {
      return 'error';
    }
  }
}
