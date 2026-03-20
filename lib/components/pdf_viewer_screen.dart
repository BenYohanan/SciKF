import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'custom_bottom_nav_bar.dart';

class PdfViewerScreen extends StatelessWidget {
  final String url;

  const PdfViewerScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      body: SfPdfViewer.network(url),
    );
  }
}