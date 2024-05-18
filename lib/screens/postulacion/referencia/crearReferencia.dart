import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/screens/educacionesScreen.dart';
import 'package:rrhh_movil/screens/experienciasScreen.dart';
import 'package:rrhh_movil/screens/referenciasScreen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;

class CrearReferencia extends StatefulWidget {
  const CrearReferencia({super.key});

  @override
  State<CrearReferencia> createState() => _CrearReferenciaState();
}

class _CrearReferenciaState extends State<CrearReferencia> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nombre = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController telefono = TextEditingController();


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
        title: const Text('Registrar Referencias'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: nombre,
                decoration:
                    const InputDecoration(labelText: 'Nombre de la referencia'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el nombre de la referencia.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descripcion,
                decoration:
                    const InputDecoration(labelText: 'Descripción de la referencia'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa la descripción de la referencia';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: telefono,
                decoration:
                    const InputDecoration(labelText: 'Telefono de la referencia'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese el telefono de la referencia';
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
          Uri.parse('${servidor.baseUrl}/postulante/referencia/$user_id');
      final request = http.MultipartRequest('POST', uri);

      request.fields['nombre'] = nombre.text;
      request.fields['descripcion'] = descripcion.text;
      request.fields['telefono'] = telefono.text;
  


      final response = await request.send();
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReferenciasScreen(userId: user_id)),
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
