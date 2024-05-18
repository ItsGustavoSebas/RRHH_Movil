import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/models/experiencias.dart';
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/models/reconocimientos.dart';
import 'package:rrhh_movil/models/referencias.dart';
import 'package:rrhh_movil/screens/educacionesScreen.dart';
import 'package:rrhh_movil/screens/experienciasScreen.dart';
import 'package:rrhh_movil/screens/reconocimientosScreen.dart';
import 'package:rrhh_movil/screens/referenciasScreen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/educacionesID.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/services/services.dart';

class EditarExperiencia extends StatefulWidget {
  final int id;

  const EditarExperiencia({required this.id, super.key});

  @override
  State<EditarExperiencia> createState() => _EditarExperienciaState();
}

class _EditarExperienciaState extends State<EditarExperiencia> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController cargo = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController anos = TextEditingController();
  TextEditingController lugar = TextEditingController();
  late ExperienciasService experienciasService;

  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();
  Experiencias? experiencia;

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();
    experienciasService = ExperienciasService();
    _loadExperiencia();
    super.initState();
  }

  //filtra para saber que educación especifica se editara
  Future<void> _loadExperiencia() async {
    final experiencias = await experienciasService.loadExperiencias(user_id);
    final experienciaFiltrada =
        experiencias.firstWhere((e) => e.id == widget.id);

    if (experienciaFiltrada != null) {
      setState(() {
        experiencia = experienciaFiltrada;
        cargo.text = experiencia!.cargo;
        descripcion.text = experiencia!.descripcion;
        anos.text = experiencia!.aos.toString();
        lugar.text = experiencia!.lugar;

        isLoading = false;
      });
    } else {
      // Manejar el caso donde no se encontró la educación
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Experiencia no encontrada'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar su Experiencia laboral'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text('ID de Experiencia: ${widget.id}'),
              SizedBox(height: 30),
              TextFormField(
                controller: cargo,
                decoration:
                    const InputDecoration(labelText: 'Nombre del cargo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese el nombre del cargo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descripcion,
                decoration: const InputDecoration(
                    labelText: 'Descripción del reconocimiento'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa la descripción del reconocimiento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: anos,
                decoration:
                    const InputDecoration(labelText: 'Años en el cargo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese los años en el cargo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: lugar,
                decoration:
                    const InputDecoration(labelText: 'Lugar donde trabajo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese el lugar donde trabajo';
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
          '${servidor.baseUrl}/postulante/actualizarExperiencia/${widget.id}');
      final request = http.MultipartRequest('POST', uri);

      request.fields['cargo'] = cargo.text;
      request.fields['descripcion'] = descripcion.text;
      request.fields['años'] = anos.text;
      request.fields['lugar'] = lugar.text;

      final response = await request.send();
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ExperienciasScreen(userId: user_id)),
        );
        print('Información actualizada con exito');
      } else {
        // Manejar errores
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hubo un error al editar la referencia'),
          ),
        );
      }
    }
  }
}
