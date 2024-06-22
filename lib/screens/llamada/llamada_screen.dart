import 'package:rrhh_movil/models/llamada.dart';
import 'package:rrhh_movil/services/llamada_service.dart';
import 'package:flutter/material.dart';

class LlamadaScreen extends StatefulWidget {
  final int empleadoId;

  LlamadaScreen({required this.empleadoId});

  @override
  _LlamadaScreenState createState() => _LlamadaScreenState();
}

class _LlamadaScreenState extends State<LlamadaScreen> {
  final LlamadaService llamadaService = LlamadaService();
  bool isLoading = true;
  String? errorMessage;
  List<LlamadaAtencion>? llamadas;

  @override
  void initState() {
    super.initState();
    loadLlamadas();
  }

  Future<void> loadLlamadas() async {
    try {
      llamadas = await llamadaService.getLlamadas(widget.empleadoId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Llamadas de Atención no encontradas';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Llamadas de Atención no encontradas'+e.toString()),
        ),
      );
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Llamadas de Atención'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : errorMessage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!),
                      SizedBox(height: 20),
                    ],
                  )
                : ListView.builder(
                    itemCount: llamadas?.length ?? 0,
                    itemBuilder: (context, index) {
                      final llamada = llamadas![index];
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${llamada.id}'),
                              Text('Motivo: ${llamada.motivo}'),
                              Text('Fecha: ${llamada.fecha.toLocal()}'),
                              Text('Gravedad: ${llamada.gravedad}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
