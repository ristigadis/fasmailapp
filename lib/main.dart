import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Wajib setelah flutterfire configure
import 'routes/app_routes.dart'; // Sesuaikan dengan folder kamu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FasMailApp());
}

class FasMailApp extends StatelessWidget {
  const FasMailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FasMail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.splash, // Atau ganti dengan route awal kamu
      routes: AppRoutes.routes,
    );
  }
}
