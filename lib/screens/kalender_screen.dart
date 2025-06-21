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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final DateTime firstDayOfMonth = DateTime(year, month, 1);
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int startWeekday = firstDayOfMonth.weekday % 7;
    final List<Widget> dayWidgets = [];

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


    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final tanggal = DateTime(year, month, day);
      final isToday = now.year == year && now.month == month && now.day == day;
      
      dayWidgets.add(Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: const TextStyle(fontSize: 16),
        ),
      ));
    }

    // Gunakan intl4x untuk mendapatkan nama bulan
   String formatTanggal(DateTime tanggal) {
      return DateFormat.yMMMMEEEEd('id_ID').format(tanggal);
    }


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           '${DateFormat.MMMM('id_ID').format(DateTime(year, month))} $year',

            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: dayWidgets,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}