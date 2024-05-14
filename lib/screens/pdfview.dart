import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;

  PDFViewerPage({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: FutureBuilder<int>(
          future: getPdfPageCount(pdfUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return PDFView(
              filePath: pdfUrl,
              enableSwipe: true,
              autoSpacing: false,
              pageSnap: true,
              defaultPage: 1,
              fitPolicy: FitPolicy.BOTH,
              onPageChanged: (int? page, int? total) {
                // Update here
                if (page != null && total != null) {
                  // Your logic when page changes
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<int> getPdfPageCount(String pdfUrl) async {
    PDFDocument doc = await PDFDocument.fromURL(pdfUrl);
    return doc.count;
  }
}
