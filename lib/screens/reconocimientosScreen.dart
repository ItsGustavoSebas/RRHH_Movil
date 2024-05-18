import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/screens/postulacion/reconocimiento/crearReconocimiento.dart';
import 'package:rrhh_movil/screens/postulacion/reconocimiento/editarReconocimiento.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:http/http.dart' as http;

class ReconocimientosScreen extends StatefulWidget {
  final String userId;

  const ReconocimientosScreen({super.key, required this.userId});

  @override
  State<ReconocimientosScreen> createState() => _ReconocimientosScreenState();
}

class _ReconocimientosScreenState extends State<ReconocimientosScreen> {
  late ReconocimientosService reconocimientosService;
  Servidor servidor = Servidor();

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    final user_id = authService.user.id.toString();
    reconocimientosService = ReconocimientosService();
    reconocimientosService.loadReconocimientos(user_id);
  }

    Future<void> _deleteReconocimiento(int idEducacion) async {
    final uri = Uri.parse('${servidor.baseUrl}/reconocimientoEliminar/$idEducacion');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reconocimiento eliminada exitosamente'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar el reconocimiento'),
        ),
      );
    }
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CrearReconocimiento()),
                    );
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditarReconocimiento(id: educacion.id),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteReconocimiento(educacion.id),
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
