import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1ABC9C),
      body: Stack(
        children: [
          // Gambar masjid di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/baground.png',
              fit: BoxFit.cover, // agar tidak terlalu zoom
              height: 220, // sesuaikan tinggi agar proporsional
            ),
          ),

          // Lapisan Warna (Opsional, agar konten tetap terbaca)
          Container(
            color: Color(0xFF1ABC9C).withOpacity(0.85),
          ),

          // Konten Utama (Logo + Teks)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
                // SizedBox(height: 10),
                Text(
                  'Ngaji',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
