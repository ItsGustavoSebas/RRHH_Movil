// dashboard_postulante.dart
import 'package:rrhh_movil/components/components.dart';
import 'package:flutter/material.dart';
import 'package:rrhh_movil/screens/mensajesScreen.dart';

class DashboardEmpleado extends StatefulWidget {
  final String userId;

  const DashboardEmpleado({Key? key, required this.userId}) : super(key: key);

  @override
  _DashboardEmpleadoState createState() => _DashboardEmpleadoState();
}

class _DashboardEmpleadoState extends State<DashboardEmpleado> {
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
        body: const Text('Empleado'));
  }
}
