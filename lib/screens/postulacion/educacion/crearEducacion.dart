import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/screens/educacionesScreen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;

class CrearEducacion extends StatefulWidget {
  const CrearEducacion({super.key});

  @override
  State<CrearEducacion> createState() => _CrearEducacionState();
}

class _CrearEducacionState extends State<CrearEducacion> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nombre_colegio = TextEditingController();
  TextEditingController grado_diploma = TextEditingController();
  TextEditingController campo_de_estudio = TextEditingController();
  TextEditingController fechaDeFinalizacion = TextEditingController();
  TextEditingController notas_adicionales = TextEditingController();

  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'), // Establece el idioma del selector
    );
    if (picked != null) {
      setState(() {
        fechaDeFinalizacion.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Educación'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: nombre_colegio,
                decoration: const InputDecoration(
                    labelText: 'Nombre del Colegio/Instituto/Universidad'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa un nombre.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: grado_diploma,
                decoration:
                    const InputDecoration(labelText: 'Grado del diploma'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el grado del diploma';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: campo_de_estudio,
                decoration:
                    const InputDecoration(labelText: 'Campo de estudio'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese el campo de estudio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: fechaDeFinalizacion,
                decoration:
                    const InputDecoration(labelText: 'Fecha de Finalzacion'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDate(context);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, selecciona la fecha de finalización.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: notas_adicionales,
                decoration:
                    const InputDecoration(labelText: 'Notas adicionales'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresar alguna nota o comentario';
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
          Uri.parse('${servidor.baseUrl}/postulante/educacion/$user_id');
      final request = http.MultipartRequest('POST', uri);

      request.fields['nombre_colegio'] = nombre_colegio.text;
      request.fields['grado_diploma'] = grado_diploma.text;
      request.fields['campo_de_estudio'] = campo_de_estudio.text;
      request.fields['fecha_de_finalizacion'] = fechaDeFinalizacion.text;
      request.fields['notas_adicionales'] = notas_adicionales.text;

      final response = await request.send();
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EducacionesScreen(userId: user_id)),
        );
        print('Información creada con exito');
      } else {
        // Manejar errores
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hubo un error al crear la asistencia'),
          ),
        );
      }
    }
  }
}
