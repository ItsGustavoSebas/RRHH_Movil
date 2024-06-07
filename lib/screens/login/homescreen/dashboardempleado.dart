import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/screens/mensajesScreen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';

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
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    final String departamento = user.departamento;
    final String cargo = user.cargo;

    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
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
                  builder: (context) =>
                      MessageListScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color:
            const Color(0xFF1A237E), // Fondo azul para el cuerpo de la pantalla
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'http://137.184.179.201/${user.foto ?? 'default.jpg'}'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            departamento,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            cargo,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: List.generate(4, (index) {
                              return const Icon(Icons.star,
                                  color: Colors.yellow);
                            })
                              ..add(
                                const Icon(Icons.star, color: Colors.grey),
                              ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              onPressed: () {
                                // Acción para marcar asistencia
                              },
                              child: const Text('Marcar Asistencia',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Horario',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Horario de Entrada: 8:00 AM',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      'Horario de Salida: 5:00 PM',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Asistencia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Fecha: 2024-06-06',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      'Estado: Presente',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
