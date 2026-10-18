import 'dart:developer';
import 'package:flutter/foundation.dart';

void appLog(dynamic message) {
  try {
    if (kDebugMode) {
      log("""
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

$message

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

""");
    }
  } catch (e) {
    debugPrint("app log $e");
  }
}

void errorLog(String message, dynamic e, {String title = "Error form"}) {
  try {
    if (kDebugMode) {
      log(""""

      >>>>>>>>>>>>>>>>>>>>>>>>>>>😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


     ➡️➡️➡️➡️➡️➡️➡️ $title ➡️➡️➡️➡️➡️➡️ $message >>> ${e.toString()} 🔚🔚🔚🔚🔚🔚🔚🔚
      

      <<<<<<<<<<<<<<<<<<<<<<<<<<<😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      """);
    }
  } catch (e) {
    debugPrint("error log $e");
  }
}
