import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/screens/permisos/crearPermiso.dart';
import 'package:rrhh_movil/screens/permisos/editarPermiso.dart';
import 'package:rrhh_movil/services/permiso_service.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:rrhh_movil/models/models.dart';

class PermisosView extends StatefulWidget {
  const PermisosView({super.key});

  @override
  State<PermisosView> createState() => _PermisosViewState();
}

class _PermisosViewState extends State<PermisosView> {
  late PermisosService permisosService;
  late String userId;

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    userId = authService.user.id.toString();
    permisosService = PermisosService();
    permisosService.loadPermisos(userId);
  }

  Future<void> _deletePermiso(int idPermiso) async {
    final servidor = Servidor();
    final uri =
        Uri.parse('${servidor.baseUrl}/empleado/eliminarPermiso/$idPermiso');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permiso eliminado exitosamente'),
        ),
      );
      await permisosService.loadPermisos(userId); // Recargar permisos
      setState(() {}); // Actualizar la interfaz
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar el permiso'),
        ),
      );
    }
  }

  String obtenerEstado(Permisos permiso) {
    if (permiso.aprobado == 1) {
      return "Aprobado";
    } else if (permiso.denegado == 1) {
      return "Denegado";
    } else {
      return "Pendiente";
    }
  }

  TextStyle getEstadoStyle(String estado) {
    switch (estado) {
      case "Aprobado":
        return TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
      case "Denegado":
        return TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
      case "Pendiente":
        return TextStyle(color: Colors.amber, fontWeight: FontWeight.bold);
      default:
        return TextStyle(color: Colors.black, fontWeight: FontWeight.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PermisosService>(
      create: (_) => permisosService,
      child: Consumer<PermisosService>(
        builder: (context, permisosService, child) {
          if (permisosService.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Permisos'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CrearPermiso()),
                    );
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: permisosService.permisos.length,
              itemBuilder: (context, index) {
                final permiso = permisosService.permisos[index];
                final estado = obtenerEstado(permiso);
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
                        Text('ID: ${permiso.id}'),
                        Text('Motivo: ${permiso.motivo}'),
                        Text(
                            'Fecha de Inicio: ${permiso.fechaInicio.toLocal().toString().split(' ')[0]}'),
                        Text(
                            'Fecha de Fin: ${permiso.fechaFin.toLocal().toString().split(' ')[0]}'),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Estado: ',
                                style: TextStyle(
                                  color: Colors.black,
                                 
                                ),
                              ),
                              TextSpan(
                                  text: obtenerEstado(permiso),
                                  style: getEstadoStyle(estado)),
                            ],
                          ),
                        ),
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
                                        EditarPermiso(id: permiso.id),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletePermiso(permiso.id),
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
