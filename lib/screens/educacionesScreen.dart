import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/services/services.dart';

class EducacionesScreen extends StatefulWidget {
  final String userId;

  const EducacionesScreen({super.key, required this.userId});

  @override
  State<EducacionesScreen> createState() => _EducacionesScreenState();
}

class _EducacionesScreenState extends State<EducacionesScreen> {
  late EducacionesService educacionesService;

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    final user_id = authService.user.id.toString();
    educacionesService = EducacionesService();
    educacionesService.loadEducaciones(user_id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EducacionesService>(
      create: (_) => educacionesService,
      child: Consumer<EducacionesService>(
        builder: (context, educacionesService, child) {
          if (educacionesService.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Educaciones'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Implementar lógica para añadir nueva educación
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: educacionesService.educaciones.length,
              itemBuilder: (context, index) {
                final educacion = educacionesService.educaciones[index];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${educacion.id}'),
                        Text('Nombre del colegio: ${educacion.nombreColegio}'),
                        Text('Grado Diploma: ${educacion.gradoDiploma}'),
                        Text('Campo de estudio: ${educacion.campoDeEstudio}'),
                        Text('Fecha de finalización: ${educacion.fechaDeFinalizacion.toLocal().toString().split(' ')[0]}'),
                        Text('Notas adicionales: ${educacion.notasAdicionales}'),
                        Text('Postulante: ${educacion.idPostulante}'),
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
