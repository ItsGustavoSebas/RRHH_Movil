import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class AsistenciaService extends ChangeNotifier {
  bool isLoading = true;
  Servidor servidor = Servidor();
  Future<List<Horario>> getHorario(int userId) async {
    isLoading = true;

    List<Horario> horarios = [];

    final resp = await http.get(Uri.parse('${servidor.baseUrl}/empleado/horario/$userId'));

    if (resp.statusCode == 200) {
      final List<dynamic> horariosMap = json.decode(resp.body)['horarios'];

      horariosMap.forEach((element) {
        final map = Horario.fromMap(element);
        horarios.add(map);
      });

      isLoading = false;
      notifyListeners();
      return horarios;
    } else {
      isLoading = false;
      notifyListeners();
      throw Exception('Error al obtener los horarios');
    }
  }

  Future<Map<String, dynamic>> marcar(int userId) async {
    final url = Uri.parse('${servidor.baseUrl}/empleado/marcar/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener datos para marcar asistencia');
    }
  }

  Future<String> guardarAsistencia(int userId, int idDiaTrabajo) async {
    final url = Uri.parse('${servidor.baseUrl}/empleado/guardarAsistencia/$userId/$idDiaTrabajo');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['message'];
    } else {
      throw Exception('Error al guardar la asistencia');
    }
  }

  Future<String> verificarFaltasAutomaticas() async {
    final url = Uri.parse('${servidor.baseUrl}/empleado/guardarAsistenciaAuto');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['message'];
    } else {
      throw Exception('Error al verificar faltas automáticas');
    }
  }
}

