import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/screens/permisos/permisosView.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/notificaciones.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  late NotificacionesService notificacionesService;
  late String userId;

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    userId = authService.user.id.toString();
    notificacionesService = NotificacionesService();
    notificacionesService.loadNotificaciones(userId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificacionesService>(
      create: (_) => notificacionesService,
      child: Consumer<NotificacionesService>(
        builder: (context, notificacionesService, child) {
          if (notificacionesService.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Notificaciones'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.mark_email_read),
                  onPressed: () async {
                    await notificacionesService.marcarTodasComoLeidas(userId);
                    notificacionesService.loadNotificaciones(userId);
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: notificacionesService.notificaciones.length,
              itemBuilder: (context, index) {
                final notificacion =
                    notificacionesService.notificaciones[index];
                final isRead = notificacion.readAt != null;

                return GestureDetector(
                  onTap: () async {
                    await notificacionesService.marcarComoLeida(
                        userId, notificacion.id.toString());
                    notificacionesService.loadNotificaciones(userId);
                    if (notificacion.data.type == 'permisoaceptado' ||
                        notificacion.data.type == 'permisorechazada' ||
                        notificacion.data.type == 'permisonuevo') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PermisosView()), // Reemplazar con la vista de permisos
                      );
                    } else if (notificacion.data.type == 'entrevista') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NotificacionesScreen()), // Reemplazar con la vista de la entrevista
                      );
                    } else if (notificacion.data.type == 'contrato') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NotificacionesScreen()), // Reemplazar con la vista del contrato
                      );
                    }
                  },
                  child: Card(
                    color: isRead ? Colors.grey[300] : Colors.white,
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notificacion.data.titulo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            notificacion.data.contenido,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
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
