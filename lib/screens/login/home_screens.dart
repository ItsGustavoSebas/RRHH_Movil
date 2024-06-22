// home_screen.dart
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rrhh_movil/screens/screens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    readToken();
    super.initState();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<AuthService>(context, listen: false).tryToken(token);
    print(token);
  }

  Future<bool> hasRole(String userId, String role) async {
    final response = await http
        .get(Uri.parse('http://137.184.179.201/api/getRol/$userId/$role'));

    if (response.statusCode == 200) {
      return json.decode(response.body) == true;
    } else {
      throw Exception('Failed to load role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, child) {
      if (!auth.authentificated) {
        return Scaffold(
          body: WelcomeScreen(),
        );
      } else {
        if (auth.user.postulante == 1) {
          final user_id = auth.user.id.toString();
          return DashboardPostulante(userId: user_id);
        } else {
          final user_id = auth.user.id.toString();
          return FutureBuilder<List<bool>>(
            future: Future.wait([
              hasRole(user_id, 'Administrador'),
              hasRole(user_id, 'Encargado'),
            ]),
            builder: (context, AsyncSnapshot<List<bool>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else {
                bool isAdminOrManager = snapshot.data![0] || snapshot.data![1];

                if (isAdminOrManager) {
                  final user_id = auth.user.id.toString();
                  return DashboardAdministrador(userId: user_id);
                } else {
                  final user_id = auth.user.id.toString();
                  return DashboardEmpleado(userId: user_id);
                }
              }
            },
          );
        }
      }
    });
  }
}
