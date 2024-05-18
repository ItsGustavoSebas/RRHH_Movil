// dashboard_postulante.dart
import 'package:rrhh_movil/components/components.dart';
import 'package:flutter/material.dart';
import 'package:rrhh_movil/screens/mensajesScreen.dart';

class DashboardAdministrador extends StatefulWidget {
  final String userId;

  const DashboardAdministrador({Key? key, required this.userId})
      : super(key: key);

  @override
  _DashboardAdministradorState createState() => _DashboardAdministradorState();
}

class _DashboardAdministradorState extends State<DashboardAdministrador> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideBar(),
        appBar: AppBar(
          title: const Text('Recursos Humanos'),
          actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageListScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
        ),
        body: const Text('Administrador'));
  }
}
