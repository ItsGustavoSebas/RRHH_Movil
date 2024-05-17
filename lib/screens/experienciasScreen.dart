import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/services/services.dart';

class ExperienciasScreen extends StatefulWidget {
  final String userId;

  const ExperienciasScreen({super.key, required this.userId});

  @override
  State<ExperienciasScreen> createState() => _ExperienciasScreenState();
}

class _ExperienciasScreenState extends State<ExperienciasScreen> {
  late ExperienciasService experienciasService;

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    final user_id = authService.user.id.toString();
    experienciasService = ExperienciasService();
    experienciasService.loadExperiencias(user_id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExperienciasService>(
      create: (_) => experienciasService,
      child: Consumer<ExperienciasService>(
        builder: (context, experienciasService, child) {
          if (experienciasService.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Experiencias'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Implementar lógica para añadir nueva experiencia
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: experienciasService.experiencias.length,
              itemBuilder: (context, index) {
                final educacion = experienciasService.experiencias[index];
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
                        Text('Cargo: ${educacion.cargo}'),
                        Text('Descripcion: ${educacion.descripcion}'),
                        Text('Años: ${educacion.aos}'),
                        Text('Lugar: ${educacion.lugar}'),
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
