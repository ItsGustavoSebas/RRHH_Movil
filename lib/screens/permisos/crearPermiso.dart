import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:rrhh_movil/screens/permisos/permisosView.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;

class CrearPermiso extends StatefulWidget {
  const CrearPermiso({super.key});

  @override
  State<CrearPermiso> createState() => _CrearPermisoState();
}

class _CrearPermisoState extends State<CrearPermiso> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController motivo = TextEditingController();
  TextEditingController fecha_inicio = TextEditingController();
  TextEditingController fecha_fin = TextEditingController();


  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();
    super.initState();
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
        title: const Text('Solicitar Permiso'),
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
                decoration: const InputDecoration(
                    labelText: 'Motivo del permiso'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese un motivo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
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
                    const InputDecoration(labelText: 'Fecha de Finalzacion'),
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
      final uri =
          Uri.parse('${servidor.baseUrl}/empleado/guardarPermiso/$user_id');
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
        print('Permiso creado con exito');
      } else {
        // Manejar errores
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hubo un error al crear el permiso'),
          ),
        );
      }
    }
  }
}
