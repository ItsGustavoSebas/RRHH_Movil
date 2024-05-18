import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/screens/postulacion/experiencia/crearExperiencia.dart';
import 'package:rrhh_movil/screens/postulacion/experiencia/editarExperiencia.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:http/http.dart' as http;

class ExperienciasScreen extends StatefulWidget {
  final String userId;

  const ExperienciasScreen({super.key, required this.userId});

  @override
  State<ExperienciasScreen> createState() => _ExperienciasScreenState();
}

class _ExperienciasScreenState extends State<ExperienciasScreen> {
  late ExperienciasService experienciasService;
  Servidor servidor = Servidor();

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    final user_id = authService.user.id.toString();
    experienciasService = ExperienciasService();
    experienciasService.loadExperiencias(user_id);
  }
    Future<void> _deleteExperiencia(int idEducacion) async {
    final uri = Uri.parse('${servidor.baseUrl}/experienciaEliminar/$idEducacion');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Experiencia eliminada exitosamente'),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CrearExperiencia()),
                    );
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditarExperiencia(id: educacion.id),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteExperiencia(educacion.id),
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
