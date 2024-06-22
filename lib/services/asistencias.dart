import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class AsistenciaService {

  Servidor servidor = Servidor();
  Future<List<Horario>> getHorario(int idEmpleado) async {
    final url = Uri.parse('${servidor.baseUrl}/empleado/horario/$idEmpleado');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return horarioFromMap(response.body);
    } else {
      throw Exception('Error al obtener los horarios');
    }
  }

  Future<Map<String, dynamic>> marcar(int idEmpleado) async {
    final url = Uri.parse('${servidor.baseUrl}/empleado/marcar/$idEmpleado');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener datos para marcar asistencia');
    }
  }

  Future<String> guardarAsistencia(int idEmpleado, int idDiaTrabajo) async {
    final url = Uri.parse('${servidor.baseUrl}/empleado/guardarAsistencia/$idEmpleado/$idDiaTrabajo');
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

