
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import '../widgets/dialogs.dart';

Future<void> downloadFile(String url, BuildContext context) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf";

    await Dio().download(url, filePath);
    await OpenFilex.open(filePath);
  } catch (e) {
    Dialogs.flushBar(context, "Error", "Download failed");
  }
}