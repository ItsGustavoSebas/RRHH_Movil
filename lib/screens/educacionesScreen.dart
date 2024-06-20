import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/screens/postulacion/educacion/crearEducacion.dart';
import 'package:rrhh_movil/screens/postulacion/educacion/editarEducacion.dart';
import 'package:rrhh_movil/services/permiso_service.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:http/http.dart' as http;

class EducacionesScreen extends StatefulWidget {
  final String userId;

  const EducacionesScreen({super.key, required this.userId});

  @override
  State<EducacionesScreen> createState() => _EducacionesScreenState();
}

class _EducacionesScreenState extends State<EducacionesScreen> {
  late EducacionesService educacionesService;
  Servidor servidor = Servidor();

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    final user_id = authService.user.id.toString();
    educacionesService = EducacionesService();
    educacionesService.loadEducaciones(user_id);
  }

  Future<void> _deleteEducacion(int idEducacion) async {
    final uri = Uri.parse('${servidor.baseUrl}/educacionEliminar/$idEducacion');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Educación eliminada exitosamente'),
        ),

      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar la educación'),
        ),
      );
    }
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CrearEducacion()),
                    );
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
                        Text('Nombre del colegio: ${educacion.nombreColegio}'),
                        Text('Grado Diploma: ${educacion.gradoDiploma}'),
                        Text('Campo de estudio: ${educacion.campoDeEstudio}'),
                        Text(
                            'Fecha de finalización: ${educacion.fechaDeFinalizacion.toLocal().toString().split(' ')[0]}'),
                        Text(
                            'Notas adicionales: ${educacion.notasAdicionales}'),
                        Text('Postulante: ${educacion.idPostulante}'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditarEducacion(id: educacion.id),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEducacion(educacion.id),
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
