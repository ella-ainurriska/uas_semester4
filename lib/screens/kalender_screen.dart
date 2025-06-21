// Tambahkan kode berikut dulu:
import 'package:flutter/material.dart';

class KalenderScreen extends StatelessWidget {
  const KalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalender $currentYear'),
        backgroundColor: const Color(0xFF1ABC9C),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          return MonthCalendar(year: currentYear, month: month);
        },
      ),
    );
  }
}

class MonthCalendar extends StatelessWidget {
  final int year;
  final int month;

  const MonthCalendar({required this.year, required this.month});

  const List<String> namaHari = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  dayWidgets.addAll(namaHari.map((hari) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      hari,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}));


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bulan $month, $year',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
