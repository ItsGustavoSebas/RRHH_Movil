import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/entrevista.dart';
import 'package:rrhh_movil/services/server.dart';

class EntrevistaService{
  Servidor servidor = Servidor();
  Future<Entrevista> getEntrevista(int postulanteId) async {
    final response = await http.get(Uri.parse('${servidor.baseUrl}/entrevista/$postulanteId'));
    if (response.statusCode == 200) {
      return Entrevista.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load entrevista, statusCode: ${response.statusCode}');
    }
  }
}