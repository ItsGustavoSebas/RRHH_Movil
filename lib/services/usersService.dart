import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/models/users.dart';
import 'package:rrhh_movil/services/server.dart';

class UserService extends ChangeNotifier {
  List<Users> users = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<void> fetchUsers(String userId) async {
    isLoading = true;

    final response = await http.get(Uri.parse('${servidor.baseUrl}/mensaje/usuarios/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      users = userJson.map((json) => Users.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }

    isLoading = false;
    notifyListeners();
  }
}