import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'management.dart';
import 'services/deep_link_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize deep-linking service globally
  final deepLinkService = DeepLinkService(); //Instance of DeeplinkService
  Get.put(deepLinkService);
  await deepLinkService.init();

  runApp(const Management());
}
