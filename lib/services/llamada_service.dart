import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/llamada.dart';
import 'package:rrhh_movil/services/server.dart';

class LlamadaService {
  Servidor servidor = Servidor();

  Future<List<LlamadaAtencion>> getLlamadas(int empleadoId) async {
    print('id');
    print(empleadoId);

    final response = await http.get(Uri.parse('${servidor.baseUrl}/empleado/llamada/$empleadoId'));
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<LlamadaAtencion> llamadas = jsonList.map((json) => LlamadaAtencion.fromJson(json)).toList();
      print(llamadas);
      return llamadas;
    } else {
      throw Exception('Failed to load llamadas de atención, statusCode: ${response.statusCode}');
    }
  }
}