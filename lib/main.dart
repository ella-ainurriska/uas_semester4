import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/spalash_screen.dart'; // pastikan penamaan file benar

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null); // Inisialisasi lokal Indonesia
  runApp(const NgajiApp());
}

class NgajiApp extends StatelessWidget {
  const NgajiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngaji Lite',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
