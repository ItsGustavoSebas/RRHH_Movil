import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/screens/login/login_screen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rrhh_movil/services/postulante.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  late Future<Postulante> _postulanteFuture;
  late PostulanteService _postulanteService;

  @override
  void initState() {
    readToken();
    super.initState();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<AuthService>(context, listen: false).tryToken(token);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, auth, child) {
      if (!auth.authentificated) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 248, 244, 243),
            elevation: 0, // Remove shadow
            title: const Text(
              '',
              style: TextStyle(color: Colors.black), // Text color
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GESTIÓN DE LOS PROCESOS DE RECLUTAMIENTO, SELECCIÓN, PAGOS, HORARIOS Y ADMINISTRACIÓN DE LOS RECURSOS HUMANOS',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text('Iniciar Sesión'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      } else {
        if (auth.user.postulante == 1) {
          final user_id = auth.user.id.toString();
          _postulanteService = PostulanteService();
          _postulanteFuture = _postulanteService.loadPostulante(user_id);
          return Scaffold(
            drawer: const SideBar(),
            appBar: AppBar(
              title: const Text('Recursos Humanos'),
            ),
            body: FutureBuilder<Postulante>(
              future: _postulanteFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final postulante = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(' ${postulante.nombre}'),
                          subtitle:
                              Text('Postulante para ${postulante.puesto}'),
                        ),
                        if (postulante.estado == 'incompleto') ...[
                          Text(
                            'Información incompleta',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            'Por favor, complete toda la información requerida en su solicitud para continuar con el proceso de postulación.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Divider(),
                        ],
                        if (postulante.estado == 'rechazado') ...[
                          Text(
                            'Rechazado',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            'Lamentablemente, su solicitud ha sido rechazada en esta ocasión. Sin embargo, lo invitamos a seguir revisando nuestras oportunidades de trabajo y postularse a otros puestos que puedan ser de su interés.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Divider(),
                        ],
                        if (postulante.estado == 'oferta') ...[
                          Text(
                            'Oferta extendida',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            'Le hemos extendido una oferta de empleo. Por favor, revise los términos y condiciones de la oferta y contáctenos si tiene alguna pregunta o desea discutir los detalles.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Divider(),
                          ElevatedButton(
                            onPressed: () {
                              _launchURL(
                                  'http://137.184.179.201/Contrato/PDF/${postulante.id}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .blue, // Set the background color to blue
                            ),
                            child: Text(
                                'Ver Información del contrato'), // Button text
                          )
                        ],
                        if (postulante.estado == 'pendiente') ...[
                          Text(
                            'Pendiente de revisión',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            'Su solicitud ha sido enviada y está siendo revisada por el equipo de  reclutamiento. Por favor, espere mientras procesamos su solicitud.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Divider(),
                        ],
                        if (postulante.estado == 'entrevista') ...[
                          Text(
                            'Programado para entrevista',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            'Ha sido programado para una entrevista. Por favor, asegúrese de prepararse adecuadamente y estar disponible en el momento programado.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Divider(),
                        ],
                        if (postulante.estado == 'entrevistado') ...[
                          Text(
                            'Entrevista realizada',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            'Ha completado con éxito la entrevista. Ahora estamos evaluando su desempeño y pronto nos pondremos en contacto con usted con más información.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Divider(),
                        ],

                        // Detalles de contacto
                        Text('CI: ${postulante.ci}'),
                        Text('Teléfono: ${postulante.telefono}'),
                        Text('Dirección: ${postulante.direccion}'),
                        Text('Correo: ${postulante.email}'),
                        Divider(), // Separador

                        // Información personal adicional
                        ListTile(
                          title: Text('Información Personal'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Fecha de nacimiento: ${postulante.fechaDeNacimiento.toString()}'),
                              Text('Nacionalidad: ${postulante.nacionalidad}'),
                              Text('Habilidades: ${postulante.habilidades}'),
                              Text(
                                  'Fuente de Contratación: ${postulante.fuenteDeContratacion}'),
                              Text(
                                  'Idioma Secundario: ${postulante.idioma} - ${postulante.nivelIdioma}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        } else {
          return Scaffold(
            drawer: const SideBar(),
            appBar: AppBar(
              title: const Text('Recursos Humanos'),
            ),
            body: const Text('data'),
          );
        }
      }
    });
  }

  _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'No se puede abrir la URL: $url';
      }
    } catch (e) {
      print('Error al abrir la URL: $e');
    }
  }
}
