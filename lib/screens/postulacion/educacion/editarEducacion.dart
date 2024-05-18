import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/screens/educacionesScreen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/educacionesID.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/services/services.dart';

class EditarEducacion extends StatefulWidget {
  final int id;

  const EditarEducacion({required this.id, super.key});

  @override
  State<EditarEducacion> createState() => _EditarEducacionState();
}

class _EditarEducacionState extends State<EditarEducacion> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nombre_colegio = TextEditingController();
  TextEditingController grado_diploma = TextEditingController();
  TextEditingController campo_de_estudio = TextEditingController();
  TextEditingController fechaDeFinalizacion = TextEditingController();
  TextEditingController notas_adicionales = TextEditingController();
  late EducacionesService educacionesService;

  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();
  Educaciones? educacion;

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();
    educacionesService = EducacionesService();
    _loadEducacion();
    super.initState();
  }

  //filtra para saber que educación especifica se editara
  Future<void> _loadEducacion() async {
    final educaciones = await educacionesService.loadEducaciones(user_id);
    final educacionFiltrada = educaciones.firstWhere((e) => e.id == widget.id);

    if (educacionFiltrada != null) {
      setState(() {
        educacion = educacionFiltrada;
        nombre_colegio.text = educacion!.nombreColegio;
        grado_diploma.text = educacion!.gradoDiploma;
        campo_de_estudio.text = educacion!.campoDeEstudio;
        fechaDeFinalizacion.text =
            educacion!.fechaDeFinalizacion.toLocal().toString().split(' ')[0];
        notas_adicionales.text = educacion!.notasAdicionales ?? '';
        isLoading = false;
      });
    } else {
      // Manejar el caso donde no se encontró la educación
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Educación no encontrada'),
        ),
      );
    }
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
        title: const Text('Editar su Educación'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text('ID de Educación: ${widget.id}'),
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
      final uri = Uri.parse(
          '${servidor.baseUrl}/postulante/actualizarEducacion/${widget.id}');
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
            content: Text('Hubo un error al crear la educación'),
          ),
        );
      }
    }
  }
}
