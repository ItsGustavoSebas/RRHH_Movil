import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/models/permiso.dart';
import 'package:rrhh_movil/screens/educacionesScreen.dart';
import 'package:rrhh_movil/screens/permisos/permisosView.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/permiso_service.dart';

import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/services/services.dart';

class EditarPermiso extends StatefulWidget {
  final int id;

  const EditarPermiso({required this.id, super.key});

  @override
  State<EditarPermiso> createState() => _EditarPermisoState();
}

class _EditarPermisoState extends State<EditarPermiso> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController motivo = TextEditingController();
  TextEditingController fecha_inicio = TextEditingController();
  TextEditingController fecha_fin = TextEditingController();

  late PermisosService permisosService;

  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();
  Permisos? permiso;

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();
    permisosService = PermisosService();
    _loadPermisos();
    super.initState();
  }

  //filtra para saber que educación especifica se editara
  Future<void> _loadPermisos() async {
    final permisos = await permisosService.loadPermisos(user_id);
    final permisoFiltrado = permisos.firstWhere((e) => e.id == widget.id);

    if (permisoFiltrado != null) {
      setState(() {
        permiso = permisoFiltrado;
        motivo.text = permiso!.motivo;

        fecha_inicio.text =
            permiso!.fechaInicio.toLocal().toString().split(' ')[0];
        fecha_fin.text = permiso!.fechaFin.toLocal().toString().split(' ')[0];

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permiso no encontrada'),
        ),
      );
    }
  }

  Future<void> _selectDateInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'), // Establece el idioma del selector
    );
    if (picked != null) {
      setState(() {
        fecha_inicio.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectDateFin(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'), // Establece el idioma del selector
    );
    if (picked != null) {
      setState(() {
        fecha_fin.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar permiso solicitado'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: motivo,
                decoration:
                    const InputDecoration(labelText: 'Motivo del permiso'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa un motivo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: fecha_inicio,
                decoration:
                    const InputDecoration(labelText: 'Fecha de inicio'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDateInicio(context);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, selecciona la fecha de inicio del permiso.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: fecha_fin,
                decoration:
                    const InputDecoration(labelText: 'Fecha de Finalzacion del permiso'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDateFin(context);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, selecciona la fecha de finalización del permiso.';
                  }
                  return null;
                },
              ),
             
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formkey.currentState!.validate()) {
      final uri = Uri.parse(
          '${servidor.baseUrl}/empleado/actualizarPermiso/${widget.id}');
      final request = http.MultipartRequest('POST', uri);

      request.fields['motivo'] = motivo.text;
      request.fields['fecha_inicio'] = fecha_inicio.text;
      request.fields['fecha_fin'] = fecha_fin.text;


      final response = await request.send();
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PermisosView()),
        );
        print('Permiso editado con exito');
      } else {
        // Manejar errores
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hubo un error al editar el permiso'),
          ),
        );
      }
    }
  }
}
