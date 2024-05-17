import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/services/services.dart';

class ReferenciasScreen extends StatefulWidget {
  final String userId;

  const ReferenciasScreen({super.key, required this.userId});

  @override
  State<ReferenciasScreen> createState() => _ReferenciasScreenState();
}

class _ReferenciasScreenState extends State<ReferenciasScreen> {
  late ReferenciasService referenciasService;

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    final user_id = authService.user.id.toString();
    referenciasService = ReferenciasService();
    referenciasService.loadReferencias(user_id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReferenciasService>(
      create: (_) => referenciasService,
      child: Consumer<ReferenciasService>(
        builder: (context, referenciasService, child) {
          if (referenciasService.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Referencias'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Implementar lógica para añadir nueva referencia
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: referenciasService.referencias.length,
              itemBuilder: (context, index) {
                final educacion = referenciasService.referencias[index];
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
                        Text('Telefono: ${educacion.telefono}'),
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
