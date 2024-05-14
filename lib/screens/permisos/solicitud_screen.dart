import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SolicitudScreen extends StatefulWidget {
  const SolicitudScreen({super.key});

  @override
  _SolicitudScreenState createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends State<SolicitudScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _motivoController;
  late TextEditingController _fechaInicioController;
  late TextEditingController _fechaFinController;

  final String baseUrl = 'http://10.0.2.2:8000/api'; // Cambia esto por tu URL base
  final headers = {'Content-type': 'application/json'};

  @override
  void initState() {
    super.initState();
    _motivoController = TextEditingController();
    _fechaInicioController = TextEditingController();
    _fechaFinController = TextEditingController();
  }

  @override
  void dispose() {
    _motivoController.dispose();
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    super.dispose();
  }

  Future<void> _enviarSolicitud() async {
    if (_formKey.currentState!.validate()) {
      final motivo = _motivoController.text;
      final fechaInicio = _fechaInicioController.text;
      final fechaFin = _fechaFinController.text;

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/permisos/enviar-solicitud'),
          body: jsonEncode({
            'motivo': motivo,
            'fecha_inicio': fechaInicio,
            'fecha_fin': fechaFin,
          }),
          headers: headers,
        );

        if (response.statusCode == 200) {
          // Solicitud enviada exitosamente
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Solicitud enviada'),
              content: Text('Tu solicitud de permiso ha sido enviada exitosamente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Error al enviar la solicitud
          throw Exception('Error al enviar la solicitud');
        }
      } catch (e) {
        // Error de conexión
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('Ocurrió un error al enviar la solicitud. Por favor, inténtalo nuevamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Permiso'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _motivoController,
                decoration: InputDecoration(labelText: 'Motivo del Permiso'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el motivo del permiso';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _fechaInicioController,
                decoration: InputDecoration(labelText: 'Fecha de Inicio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona la fecha de inicio';
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _fechaFinController,
                decoration: InputDecoration(labelText: 'Fecha de Fin'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona la fecha de fin';
                  }
                  return null;
                },
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _enviarSolicitud,
                child: Text('Enviar Solicitud'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
