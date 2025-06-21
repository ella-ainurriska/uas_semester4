import 'package:flutter/material.dart';
import '../services/api_sholat_service.dart';
import 'package:coba3/models/ayat_model.dart';

class SurahDetailScreen extends StatefulWidget {
  final int nomor;
  const SurahDetailScreen({super.key, required this.nomor});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late Future<List<Ayat>> futureAyat;

  @override
  void initState() {
    super.initState();
    futureAyat = SholatService.fetchAyat(widget.nomor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Surah ${widget.nomor}")),
      body: FutureBuilder<List<Ayat>>(
        future: futureAyat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat ayat'));
          } else if (snapshot.hasData) {
            final ayatList = snapshot.data!;
            return ListView.builder(
              itemCount: ayatList.length,
              itemBuilder: (context, index) {
                final ayat = ayatList[index];
                return ListTile(
                  title: Text('${ayat.no}. ${ayat.ar}'),        // ganti teksArab jadi arab
                  subtitle: Text(ayat.idn),                        // ganti teksIndonesia jadi indonesia
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      ),
    );
  }
}
