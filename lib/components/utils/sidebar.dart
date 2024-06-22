
import 'package:rrhh_movil/screens/llamada/llamada_screen.dart';

import 'package:rrhh_movil/screens/permisos/permisosView.dart';

import 'package:rrhh_movil/screens/screens.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthService>(builder: (context, auth, child) {
        if (!auth.authentificated) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar Sesión'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
            ],
          );
        } else {
          return ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(auth.user.name),
                accountEmail: Text(auth.user.email),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: auth.user.foto != null
                        ? Image.network(
                            'http://10.0.2.2:8000/${auth.user.foto}',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          )
                        : Text(
                            auth.user.name.isNotEmpty
                                ? auth.user.name[0].toUpperCase()
                                : '?', // Mostrar '?' si el nombre está vacío
                            style: TextStyle(fontSize: 24),
                          ),
                  ),
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/utils/sidebar_fondo.jpg'),
                        fit: BoxFit.cover)),
              ),
              const Divider(
                thickness: 3,
                indent: 15,
                endIndent: 15,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar Sesión'),
                onTap: () {
                  Provider.of<AuthService>(context, listen: false).logout();
                },
              ),
              ListTile(
                leading: Icon(Icons.book_sharp),
                title: Text(
                  'Gestionar mis permisos',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute( builder: (context) => const PermisosView()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Llamadas de Atención'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LlamadaScreen(empleadoId: auth.user.id), // Asegúrate de tener el ID de la entrevista
                    ),
                  );              
                },
              ),
            ],
          );
        }
      }),
    );
  }
}
