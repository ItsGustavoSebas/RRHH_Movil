import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/models/models.dart';
import 'package:rrhh_movil/models/reconocimientos.dart';
import 'package:rrhh_movil/models/referencias.dart';
import 'package:rrhh_movil/screens/educacionesScreen.dart';
import 'package:rrhh_movil/screens/reconocimientosScreen.dart';
import 'package:rrhh_movil/screens/referenciasScreen.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/educacionesID.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;
import 'package:rrhh_movil/services/services.dart';

class EditarReconocimiento extends StatefulWidget {
  final int id;

  const EditarReconocimiento({required this.id, super.key});

  @override
  State<EditarReconocimiento> createState() => _EditarReconocimientoState();
}

class _EditarReconocimientoState extends State<EditarReconocimiento> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nombre = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController telefono = TextEditingController();
  late ReconocimientosService reconocimientosService;

  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();
  Reconocimientos? reconocimiento;

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();
    reconocimientosService = ReconocimientosService();
    _loadReconocimiento();
    super.initState();
  }

  //filtra para saber que educación especifica se editara
  Future<void> _loadReconocimiento() async {
    final reconocimientos = await reconocimientosService.loadReconocimientos(user_id);
    final reconocimientoFiltrada = reconocimientos.firstWhere((r) => r.id == widget.id);

    if (reconocimientoFiltrada != null) {
      setState(() {
        reconocimiento = reconocimientoFiltrada;
        nombre.text = reconocimiento!.nombre;
        descripcion.text = reconocimiento!.descripcion;
       
        isLoading = false;
      });
    } else {
      // Manejar el caso donde no se encontró la educación
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reconocimiento no encontrada'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar su Reconocimiento'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text('ID de Reconocimiento: ${widget.id}'),
              SizedBox(height: 30),
              TextFormField(
                controller: nombre,
                decoration:
                    const InputDecoration(labelText: 'Nombre del reconocimiento'),
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
                    labelText: 'Descripción del reconocimiento'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa la descripción del reconocimiento';
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
          '${servidor.baseUrl}/postulante/actualizarReconocimiento/${widget.id}');
      final request = http.MultipartRequest('POST', uri);

      request.fields['nombre'] = nombre.text;
      request.fields['descripcion'] = descripcion.text;



      final response = await request.send();
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReconocimientosScreen(userId: user_id)),
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
