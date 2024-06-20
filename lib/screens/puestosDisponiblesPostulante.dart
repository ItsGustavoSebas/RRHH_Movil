import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/puestosDisponibles.dart';

class PuestosDisponiblePostulanteScreen extends StatefulWidget {
  const PuestosDisponiblePostulanteScreen({super.key});

  @override
  State<PuestosDisponiblePostulanteScreen> createState() =>
      _PuestosDisponiblePostulanteScreenState();
}

class _PuestosDisponiblePostulanteScreenState
    extends State<PuestosDisponiblePostulanteScreen> {
  late PuestosDisponiblesService puestosDisponiblesService;
  late String userId;
  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    userId = authService.user.id.toString();
    puestosDisponiblesService = PuestosDisponiblesService();
    puestosDisponiblesService.loadPuestosDisponible();
  }

  Future<void> _postularse(BuildContext context, String userId, String puestoId) async {
    final result = await puestosDisponiblesService.postularse(userId, puestoId);
    if (result == 'hecho') {
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Postulación exitosa')));
      Navigator.pushReplacementNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al postularse: $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PuestosDisponiblesService>(
      create: (_) => puestosDisponiblesService,
      child: Consumer<PuestosDisponiblesService>(
        builder: (context, puestosDisponiblesService, child) {
          if (puestosDisponiblesService.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Notificaciones'),
            ),
            body: ListView.builder(
              itemCount: puestosDisponiblesService.puestosDisponible.length,
              itemBuilder: (context, index) {
                final puestosDisponible =
                    puestosDisponiblesService.puestosDisponible[index];
                return Card(
                  elevation: 4.0,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          puestosDisponible.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          puestosDisponible.informacion,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Puestos disponibles: ${puestosDisponible.disponible.toString()}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _postularse(context, userId, puestosDisponible.id.toString());
                          },
                          child: const Text('Postularse'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
