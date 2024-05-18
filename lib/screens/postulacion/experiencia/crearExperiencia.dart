import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/screens/educacionesScreen.dart';
import 'package:rrhh_movil/screens/experienciasScreen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;

class CrearExperiencia extends StatefulWidget {
  const CrearExperiencia({super.key});

  @override
  State<CrearExperiencia> createState() => _CrearExperienciaState();
}

class _CrearExperienciaState extends State<CrearExperiencia> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController cargo = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController anos = TextEditingController();
  TextEditingController lugar = TextEditingController();

  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Experiencia Laboral'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: cargo,
                decoration:
                    const InputDecoration(labelText: 'Nombre del cargo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el nombre del cargo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descripcion,
                decoration:
                    const InputDecoration(labelText: 'Descripción del cargo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa la descripción del cargo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
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
      final uri =
          Uri.parse('${servidor.baseUrl}/postulante/experiencia/$user_id');
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
        print('Información creada con exito');
      } else {
        // Manejar errores
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hubo un error al crear la experiencia laboral'),
          ),
        );
      }
    }
  }
}
