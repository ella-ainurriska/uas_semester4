import 'package:flutter/material.dart';
import 'package:coba3/models/surah_model.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<Surah> _surahList = [];
  bool isLoading = true;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Al-Qur'an"),
      ),
      body: Center(
        child: Text("Menyiapkan data..."),
      ),
    );
  }
}
