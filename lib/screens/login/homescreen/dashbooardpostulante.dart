// dashboard_postulante.dart
import 'package:rrhh_movil/components/components.dart';
import 'package:flutter/material.dart';
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/screens/postulacion/postulanteinfo.dart';
import 'package:rrhh_movil/screens/postulacion/postulanteinfoEdit.dart';
import 'package:rrhh_movil/screens/mensajesScreen.dart';
import 'package:rrhh_movil/screens/screens.dart';
import 'package:rrhh_movil/services/postulante.dart';

class DashboardPostulante extends StatefulWidget {
  final String userId;

  const DashboardPostulante({Key? key, required this.userId}) : super(key: key);

  @override
  _DashboardPostulanteState createState() => _DashboardPostulanteState();
}

class _DashboardPostulanteState extends State<DashboardPostulante> {
  late Future<Postulante> _postulanteFuture;
  late PostulanteService _postulanteService;

  @override
  void initState() {
    super.initState();
    _postulanteService = PostulanteService();
    _postulanteFuture = _postulanteService.loadPostulante(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text('Recursos Humanos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageListScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Postulante>(
        future: _postulanteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Navegar a otra vista y reemplazar la actual
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => postulanteinfo()),
              );
            });

            // Mientras se realiza la navegación, devuelve un contenedor vacío o cualquier widget de carga
            return Container();
          } else {
            final postulante = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'http://10.0.2.2:8000/${postulante.foto}'), // Reemplaza con la URL de la imagen del usuario
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (postulante.estado == 'incompleto') ...[
                            ElevatedButton(
                              onPressed: () {
                                // Acción del botón "Información del contrato"
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // Color de fondo del botón
                              ),
                              child: const Text(
                                'Puestos Disponibles',
                                style: TextStyle(
                                  color:
                                      Colors.white, // Color del texto del botón
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (postulante.estado == 'oferta') ...[
                            ElevatedButton(
                              onPressed: () {
                                // Acción del botón "Información del contrato"
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // Color de fondo del botón
                              ),
                              child: const Text(
                                'Información del contrato',
                                style: TextStyle(
                                  color:
                                      Colors.white, // Color del texto del botón
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (postulante.estado == 'entrevista') ...[
                            ElevatedButton(
                              onPressed: () {
                                // Acción del botón "Información del contrato"
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // Color de fondo del botón
                              ),
                              child: const Text(
                                'Información de la entrevista',
                                style: TextStyle(
                                  color:
                                      Colors.white, // Color del texto del botón
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>postulanteinfoEdit(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey, // Color de fondo del botón
                            ),
                            child: const Text(
                              'Editar Información',
                              style: TextStyle(
                                color:
                                    Colors.white, // Color del texto del botón

                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardPostulante(
                                      userId: widget.userId),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey, // Color de fondo del botón
                            ),
                            child: const Text(
                              'Verificar Postulación',
                              style: TextStyle(
                                color:
                                    Colors.white, // Color del texto del botón

                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ' ${postulante.nombre}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Postulante para ${postulante.puesto}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  if (postulante.estado == 'incompleto') ...[
                    Text(
                      'Información incompleta',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Por favor, complete toda la información requerida (Educaciones, Reconocimientos, Experiencias, Referencias) en su solicitud para continuar con el proceso de postulación.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  if (postulante.estado == 'oferta') ...[
                    Text(
                      'Oferta extendida',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Le hemos extendido una oferta de empleo. Por favor, revise los términos y condiciones de la oferta y contáctenos si tiene alguna pregunta o desea discutir los detalles.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  if (postulante.estado == 'rechazado') ...[
                    Text(
                      'Rechazado',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lamentablemente, su solicitud ha sido rechazada en esta ocasión. Sin embargo, lo invitamos a seguir revisando nuestras oportunidades de trabajo y postularse a otros puestos que puedan ser de su interés.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  if (postulante.estado == 'pendiente') ...[
                    Text(
                      'Pendiente de revisión',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Su solicitud ha sido enviada y está siendo revisada por el equipo de  reclutamiento. Por favor, espere mientras procesamos su solicitud.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  if (postulante.estado == 'entrevista') ...[
                    Text(
                      'Programado para entrevista',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ha sido programado para una entrevista. Por favor, asegúrese de prepararse adecuadamente y estar disponible en el momento programado.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  if (postulante.estado == 'entrevistado') ...[
                    Text(
                      'Entrevista realizada',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ha completado con éxito la entrevista. Ahora estamos evaluando su desempeño y pronto nos pondremos en contacto con usted con más información.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EducacionesScreen(userId: widget.userId),
                              ),
                            );
                          },
                          child: const Text(
                            'Educaciones',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReconocimientosScreen(
                                    userId: widget.userId),
                              ),
                            );
                          },
                          child: const Text(
                            'Reconocimientos',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExperienciasScreen(userId: widget.userId),
                              ),
                            );
                          },
                          child: const Text(
                            'Experiencias',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReferenciasScreen(userId: widget.userId),
                              ),
                            );
                          },
                          child: const Text(
                            'Referencias',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información Personal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'CI: ${postulante.ci}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Teléfono: ${postulante.telefono}',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Dirección: ${postulante.direccion}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Correo: ${postulante.email}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Fecha de nacimiento: ${postulante.fechaDeNacimiento.day}-${postulante.fechaDeNacimiento.month}-${postulante.fechaDeNacimiento.year}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Nacionalidad: ${postulante.nacionalidad}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Habilidades: ${postulante.habilidades}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Fuente de Contratación: ${postulante.fuenteDeContratacion}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Idioma Secundario: ${postulante.idioma} - ${postulante.nivelIdioma}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
