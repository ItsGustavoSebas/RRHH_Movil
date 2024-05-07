import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/screens/login/login_screen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, child) {
      if (!auth.authentificated) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 248, 244, 243),
            elevation: 0, // Remove shadow
            title: const Text(
              '',
              style: TextStyle(color: Colors.black), // Text color
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GESTIÓN DE LOS PROCESOS DE RECLUTAMIENTO, SELECCIÓN, PAGOS, HORARIOS Y ADMINISTRACIÓN DE LOS RECURSOS HUMANOS',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
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
      } else {
        // Si el usuario está autenticado, no mostramos nada o cualquier otro widget
        return Scaffold(
          drawer: const SideBar(),
          appBar: AppBar(
            title: const Text('Recursos Humanos'),
          ),
          body: const Text('data'),
        );
      }
    });
  }
}
