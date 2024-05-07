import 'package:rrhh_movil/screens/login/login_screen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    readToken();
    super.initState();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    // ignore: use_build_context_synchronously
    Provider.of<AuthService>(context, listen: false).tryToken(token);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestión de las actividades y comunicados para nuestra escuela',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Desde la organización de actividades hasta la comunicación con padres y alumnos, nuestra plataforma hace que la gestión escolar sea más fácil que nunca.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Text('Iniciar Sesión'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
