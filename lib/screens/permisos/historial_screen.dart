import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rrhh_movil/services/services.dart';


class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  _HistorialScreenState createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  List<dynamic> _permisos = [];
  Servidor servidor = Servidor();

  @override
  void initState() {
    super.initState();
    _fetchPermisos();
  }

  Future<void> _fetchPermisos() async {
    try {
      final response = await http.get(Uri.parse('${servidor.baseUrl}/permisos/historial'));
      if (response.statusCode == 200) {
        setState(() {
          _permisos = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Manejar el error de obtener los permisos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Permisos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _permisos.isEmpty
            ? Center(child: Text('No hay permisos registrados.'))
            : ListView.builder(
                itemCount: _permisos.length,
                itemBuilder: (context, index) {
                  var permiso = _permisos[index];
                  return Card(
                    child: ListTile(
                      title: Text(permiso['motivo']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha de Inicio: ${permiso['fecha_inicio']}'),
                          Text('Fecha de Fin: ${permiso['fecha_fin']}'),
                          Text('Solicitante: ${permiso['solicitante']}'),
                          Text('Cargo: ${permiso['cargo']}'),
                          Text('Departamento: ${permiso['departamento']}'),
                          Text('Estado: ${permiso['estado']}'),
                        ],
                      ),
                      // Agrega aquí los botones de acciones si es necesario
                    ),
                  );
                },
              ),
      ),
    );
  }
}
