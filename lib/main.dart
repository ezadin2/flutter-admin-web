import 'package:adminpanel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';

/// Entry point of Flutter App
Future<void> main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Local Storage

  // Remove # sign from url

  // Initialize Firebase & Authentication Repository
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      // .then((_) => Get.put(AuthenthicationRepository()));
  // Main App Starts here...
  runApp(const App());
}