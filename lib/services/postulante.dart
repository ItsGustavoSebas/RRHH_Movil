import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/services/services.dart';

class PostulanteService extends ChangeNotifier {
  late Postulante postulante;
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<Postulante> loadPostulante(String userId) async {
    isLoading = true;

    final response = await http.get(
        Uri.parse('${servidor.baseUrl}/postulante/$userId'));

    if (response.statusCode == 200) {
      postulante = Postulante.fromJson(json.decode(response.body));
      isLoading = false;
      notifyListeners();
      return postulante;
    } else {
      throw Exception('Failed to load postulante');
    }
  }
}
