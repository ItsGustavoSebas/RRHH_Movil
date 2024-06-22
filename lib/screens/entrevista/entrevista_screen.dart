import 'package:flutter/material.dart';
import 'package:rrhh_movil/models/entrevista.dart';
import 'package:rrhh_movil/services/entrevista_service.dart';

class EntrevistaScreen extends StatefulWidget {
  final int postulanteId;

  EntrevistaScreen({required this.postulanteId});

  @override
  _EntrevistaScreenState createState() => _EntrevistaScreenState();
}

class _EntrevistaScreenState extends State<EntrevistaScreen> {
  late Entrevista entrevista;
  final EntrevistaService entrevistaService = EntrevistaService();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadEntrevista();
  }

  Future<void> loadEntrevista() async {
    try {
      entrevista = await entrevistaService.getEntrevista(widget.postulanteId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Entrevista no encontrada';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Entrevista no encontrada'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrevista'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!),
                      SizedBox(height: 20),
                    ],
                  )
                : SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 80, left: 16, right: 16),
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 4,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Has sido seleccionado para la etapa de entrevista!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Hola, ${entrevista.postulante.nombre}:'),
                          SizedBox(height: 10),
                          Text(
                              'Es un placer comunicarte que después de revisar cuidadosamente tu aplicación para el puesto de [Nombre del Puesto], nos complace informarte que has sido seleccionado/a para avanzar en nuestro proceso de selección y participar en una entrevista.'),
                          SizedBox(height: 20),
                          Text('La entrevista se llevará a cabo en:'),
                          SizedBox(height: 10),
                          Text('Fecha: ${entrevista.fechaInicio}'),
                          Text('Hora: ${entrevista.hora}'),
                          Text('Lugar: Calle Libertad Nro 24'),
                          SizedBox(height: 20),
                          Text(
                              'Durante la entrevista, tendrás la oportunidad de discutir más a fondo tus habilidades, experiencia y expectativas con nuestro equipo de reclutamiento. También tendrás la oportunidad de aprender más sobre nuestra empresa y el rol específico para el cual estás siendo considerado/a.'),
                          SizedBox(height: 20),
                          Text(
                              'Para confirmar tu disponibilidad para la entrevista, por favor presiona en el botón de abajo'),
                          SizedBox(height: 10),
                          Text(entrevista.detalles),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF26C6DA),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              'Confirmar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '¡Saludos cordiales,',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            entrevista.usuario.nombre,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            entrevista.usuario.cargo,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '[Nombre de la Empresa]',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
