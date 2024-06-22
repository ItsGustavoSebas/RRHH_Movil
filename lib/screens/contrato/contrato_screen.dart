import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:rrhh_movil/services/server.dart';

class ContratoScreen extends StatefulWidget {
  final int postulanteId;

  ContratoScreen({required this.postulanteId});

  @override
  _ContratoScreenState createState() => _ContratoScreenState();
}

class _ContratoScreenState extends State<ContratoScreen> {
  bool isLoading = true;
  Uint8List? pdfBytes;
  Servidor servidor = Servidor();

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    try {
      int id = widget.postulanteId;
      var response = await http.get(Uri.parse('${servidor.baseUrl}/postulante/contrato/$id'));

      if (response.statusCode == 200) {
        setState(() {
          pdfBytes = response.bodyBytes;
          isLoading = false;
        });
      } else {
        // Manejar errores de descarga
        print('Error al descargar el PDF: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Manejar errores generales
      print('Error al descargar el PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contrato'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : pdfBytes != null
                ? PDFView(
                    pdfData: pdfBytes!,
                  )
                : Text('Error al cargar el PDF'),
      ),
    );
  }
}