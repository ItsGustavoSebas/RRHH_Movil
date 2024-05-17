import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/services/services.dart';

class ReconocimientosScreen extends StatefulWidget {
  final String userId;

  const ReconocimientosScreen({super.key, required this.userId});

  @override
  State<ReconocimientosScreen> createState() => _ReconocimientosScreenState();
}

class _ReconocimientosScreenState extends State<ReconocimientosScreen> {
  late ReconocimientosService reconocimientosService;

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    final user_id = authService.user.id.toString();
    reconocimientosService = ReconocimientosService();
    reconocimientosService.loadReconocimientos(user_id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReconocimientosService>(
      create: (_) => reconocimientosService,
      child: Consumer<ReconocimientosService>(
        builder: (context, reconocimientosService, child) {
          if (reconocimientosService.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Reconocimientos'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Implementar lógica para añadir nuevo reconocimiento
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: reconocimientosService.reconocimientos.length,
              itemBuilder: (context, index) {
                final educacion = reconocimientosService.reconocimientos[index];
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
                        Text('ID: ${educacion.id}'),
                        Text('Nombre: ${educacion.nombre}'),
                        Text('Descripcion: ${educacion.descripcion}'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                // Implementar lógica para editar
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Implementar lógica para eliminar
                              },
                            ),
                          ],
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
