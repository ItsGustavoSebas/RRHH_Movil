import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/models/referencias.dart';
import 'package:rrhh_movil/screens/educacionesScreen.dart';
import 'package:rrhh_movil/screens/referenciasScreen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/educacionesID.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/services/services.dart';

class EditarReferencia extends StatefulWidget {
  final int id;

  const EditarReferencia({required this.id, super.key});

  @override
  State<EditarReferencia> createState() => _EditarReferenciaState();
}

class _EditarReferenciaState extends State<EditarReferencia> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nombre = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController telefono = TextEditingController();
  late ReferenciasService referenciasService;

  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();
  Referencias? referencia;

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();
    referenciasService = ReferenciasService();
    _loadReferencia();
    super.initState();
  }

  //filtra para saber que educación especifica se editara
  Future<void> _loadReferencia() async {
    final referencias = await referenciasService.loadReferencias(user_id);
    final referenciaFiltrada = referencias.firstWhere((r) => r.id == widget.id);

    if (referenciaFiltrada != null) {
      setState(() {
        referencia = referenciaFiltrada;
        nombre.text = referencia!.nombre;
        descripcion.text = referencia!.descripcion;
        telefono.text = referencia!.telefono;
        isLoading = false;
      });
    } else {
      // Manejar el caso donde no se encontró la educación
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referencia no encontrada'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar su Referencia laboral'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text('ID de Referencia: ${widget.id}'),
              SizedBox(height: 30),
              TextFormField(
                controller: nombre,
                decoration:
                    const InputDecoration(labelText: 'Nombre de la referencia'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese un nombre.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descripcion,
                decoration: const InputDecoration(
                    labelText: 'Descripción de la referencia laboral'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa la descripción de la referencia laboral';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: telefono,
                decoration: const InputDecoration(
                    labelText: 'Telefono de la referencia'),
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
      final uri = Uri.parse(
          '${servidor.baseUrl}/postulante/actualizarReferencia/${widget.id}');
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
