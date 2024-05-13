import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rrhh_movil/models/permiso.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PermisoService extends ChangeNotifier {
  bool _isLoading = false;
  List<Permiso> _historialPermisos = [];
  final Servidor _servidor = Servidor();
  final _storage = const FlutterSecureStorage();

  bool get isLoading => _isLoading;
  List<Permiso> get historialPermisos => _historialPermisos;

  Future<void> obtenerHistorialPermisos() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.get(Uri.parse('${_servidor.baseUrl}/permisos/historial'));
      if (response.statusCode == 200) {
        List<dynamic> permisosJson = jsonDecode(response.body);
        _historialPermisos = permisosJson.map((json) => Permiso.fromJson(json)).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Error al obtener el historial de permisos');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error de conexión');
    }
  }

  Future<String> enviarSolicitudPermiso(String motivo, DateTime fechaInicio, DateTime fechaFin) async {
    try {
      final response = await http.post(
        Uri.parse('${_servidor.baseUrl}/permisos/enviar-solicitud'),
        body: jsonEncode({
          'motivo': motivo,
          'fecha_inicio': fechaInicio.toIso8601String(),
          'fecha_fin': fechaFin.toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return 'Solicitud de permiso enviada exitosamente';
      } else {
        throw Exception('Error al enviar la solicitud de permiso');
      }
    } catch (e) {
      throw Exception('Error de conexión');
    }
  }

  Future<void> aprobarPermiso(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${_servidor.baseUrl}/permisos/aprobar/$id'),
      );
      if (response.statusCode != 200) {
        throw Exception('Error al aprobar el permiso');
      }
    } catch (e) {
      throw Exception('Error de conexión');
    }
  }

  Future<void> denegarPermiso(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${_servidor.baseUrl}/permisos/denegar/$id'),
      );
      if (response.statusCode != 200) {
        throw Exception('Error al denegar el permiso');
      }
    } catch (e) {
      throw Exception('Error de conexión');
    }
  }
}
