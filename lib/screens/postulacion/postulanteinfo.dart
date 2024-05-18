import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rrhh_movil/models/fuentedecontratacion.dart';
import 'package:rrhh_movil/models/idiomas.dart';
import 'package:rrhh_movil/models/nivelidiomas.dart';
import 'package:rrhh_movil/models/puestodisponible.dart';
import 'package:rrhh_movil/screens/login/homescreen/dashbooardpostulante.dart';
import 'package:rrhh_movil/services/auth/auth_service.dart';
import 'package:rrhh_movil/services/fuente_de_contratacion.dart';
import 'package:rrhh_movil/services/idiomas.dart';
import 'package:rrhh_movil/services/nivel_ingles.dart';
import 'package:rrhh_movil/services/puesto_disponible.dart';
import 'package:rrhh_movil/services/server.dart';
import 'package:http/http.dart' as http;

class postulanteinfo extends StatefulWidget {
  const postulanteinfo({super.key});

  @override
  State<postulanteinfo> createState() => _postulanteinfoState();
}

class _postulanteinfoState extends State<postulanteinfo> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController fechaDeNacimiento = TextEditingController();
  TextEditingController nacionalidad = TextEditingController();
  TextEditingController habilidades = TextEditingController();
  TextEditingController idFuenteDeContratacion = TextEditingController();
  TextEditingController idPuestoDisponible = TextEditingController();
  TextEditingController idIdioma = TextEditingController();
  TextEditingController idNivelIdioma = TextEditingController();

  File? ruta_imagen_e;
  bool isLoading = true;
  late String user_id;
  Servidor servidor = Servidor();

  late List<Idiomas> idiomas = [];
  int? selectIdiomaId;

  late List<Nivelidiomas> nivelIdiomas = [];
  int? selectNivelIdiomaId;

  late List<Puestodisponible> puestoDisponibles = [];
  int? selectPuestoDisponibleId;

  late List<Fuentedecontratacion> fuentesDeContratacion = [];
  int? selectFuenteDeContratacionId;

  @override
  void initState() {
    final authservice = context.read<AuthService>();
    user_id = authservice.user.id.toString();

    final idiomasService = Provider.of<IdiomasService>(context, listen: false);
    idiomasService.loadIdiomas().then((loadedIdiomas) {
      setState(() {
        //guarda en la variable delcarada arriba los idiomas cargados
        idiomas = loadedIdiomas;
      });
    });

    //obtenemos el array de fuentes de contratación para mostrarlo en la vista luego xd
    final fuentesDeContratacionService =
        Provider.of<FuenteDeContratacionService>(context, listen: false);
    fuentesDeContratacionService
        .loadFuentesDeContratacion()
        .then((loadedFuentesDeContratacion) {
      setState(() {
        //guarda en la variable delcarada arriba los idiomas cargados
        fuentesDeContratacion = loadedFuentesDeContratacion;
      });
    });

    final puestoDisponibleService =
        Provider.of<PuestoDisponibleService>(context, listen: false);
    puestoDisponibleService
        .loadPuestosDisponible()
        .then((loadedPuestosDisponible) {
      setState(() {
        //guarda en la variable delcarada arriba los idiomas cargados
        puestoDisponibles = loadedPuestosDisponible;
      });
    });

    final nivelIdiomasService =
        Provider.of<NivelIdiomasService>(context, listen: false);
    nivelIdiomasService.loadNivelIdiomas().then((loadedNivelIdiomas) {
      setState(() {
        //guarda en la variable delcarada arriba los idiomas cargados
        nivelIdiomas = loadedNivelIdiomas;
      });
    });

    super.initState();
  }

  //seleccionar imagen
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        ruta_imagen_e = File(pickedFile.path);
        isLoading = false;
      });
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
        fechaDeNacimiento.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rellenar información'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Foto',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Seleccionar imagen'),
              ),
              ruta_imagen_e != null
                  ? Image.file(ruta_imagen_e!)
                  : const Text('No se ha seleccionado una imagen'),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: fechaDeNacimiento,
                decoration:
                    const InputDecoration(labelText: 'Fecha de Nacimiento'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _selectDate(context);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, selecciona su fecha de nacimiento.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nacionalidad,
                decoration: const InputDecoration(labelText: 'Nacionalidad'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa su nacionalidad.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: habilidades,
                decoration: const InputDecoration(labelText: 'Habilidades'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectFuenteDeContratacionId,
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text('Seleccione una fuente de contratación'),
                  ),
                  ...fuentesDeContratacion.map((Fuentedecontratacion fuente) {
                    return DropdownMenuItem<int>(
                      value: fuente.id,
                      child: Text(fuente.nombre),
                    );
                  }).toList(),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    selectFuenteDeContratacionId = newValue;
                  });
                  print(selectFuenteDeContratacionId);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, seleccione una fuente de contratación.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Fuente de Contratación',
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectPuestoDisponibleId,
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text('Seleccione un puesto'),
                  ),
                  ...puestoDisponibles.map((Puestodisponible puesto) {
                    return DropdownMenuItem<int>(
                      value: puesto.id,
                      child: Text(puesto.nombre),
                    );
                  }).toList(),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    selectPuestoDisponibleId = newValue;
                  });
                  print(selectPuestoDisponibleId);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, seleccione un puesto.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Puesto',
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectIdiomaId,
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text('Seleccione un idioma'),
                  ),
                  ...idiomas.map((Idiomas idioma) {
                    return DropdownMenuItem<int>(
                      value: idioma.id,
                      child: Text(idioma.nombre),
                    );
                  }).toList(),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    selectIdiomaId = newValue;
                  });
                  print(selectIdiomaId);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, seleccione un idioma.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Idioma',
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectNivelIdiomaId,
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text('Seleccione un nivel del idioma'),
                  ),
                  ...nivelIdiomas.map((Nivelidiomas nivel) {
                    return DropdownMenuItem<int>(
                      value: nivel.id,
                      child: Text(nivel.categoria),
                    );
                  }).toList(),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    selectNivelIdiomaId = newValue;
                  });
                  print(selectNivelIdiomaId);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, seleccione un nivel de idioma.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nivel de idioma',
                ),
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
          Uri.parse('${servidor.baseUrl}/postulante/actualizarinfo/$user_id');
      final request = http.MultipartRequest('POST', uri);

      request.fields['fecha_de_nacimiento'] = fechaDeNacimiento.text;
      request.fields['nacionalidad'] = nacionalidad.text;
      request.fields['habilidades'] = habilidades.text;
      request.fields['ID_Fuente_De_Contratacion'] =
          selectFuenteDeContratacionId.toString();
      request.fields['ID_Puesto_Disponible'] =
          selectPuestoDisponibleId.toString();
      request.fields['ID_Idioma'] = selectIdiomaId.toString();
      request.fields['ID_NivelIdioma'] = selectNivelIdiomaId.toString();

      if (ruta_imagen_e != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'ruta_imagen_e',
          ruta_imagen_e!.path,
        ));
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardPostulante(userId: user_id)),
        );
        print('Información actualizada con exito');
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
