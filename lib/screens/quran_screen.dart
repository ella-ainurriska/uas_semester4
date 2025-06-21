import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coba3/models/surah_model.dart';
import 'surah_detail.dart';
import 'package:coba3/models/ayat_model.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<Surah> _surahList = [];
  // late TabController _tabController;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchSurah();
  }

  Future<void> fetchSurah() async {
  final url = Uri.parse('https://api.myquran.com/v2/quran/surat/semua');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];

      // Convert List<dynamic> ke List<Surah>
      final List<Surah> surahList = data.map((json) => Surah.fromJson(json)).toList();

      print("Jumlah surah: ${surahList.length}");
      for (var s in surahList.take(5)) {
        print("${s.nomor}: ${s.namaLatin} - ${s.jumlahAyat} ayat");
      }
      print("Contoh JSON item pertama:");
      print(json.encode(data[0]));

      setState(() {
        _surahList = surahList;
        isLoading = false;
      });
    } else {
      throw Exception('Gagal fetch data: ${response.body}');
    }
  } catch (e) {
    print("Error saat fetchSurah: $e");
    setState(() {
      isLoading = false;
      isError = true;
    });
  }
}

Future<List<Ayat>> fetchAyat(int nomorSurah) async {
  final url = 'https://equran.id/api/surat/$nomorSurah';
  print("Request URL: $url");

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    print("FULL RESPONSE: $jsonData");

    final List ayatJson = jsonData['ayat']; 
    print("Jumlah ayat: ${ayatJson.length}");

    return ayatJson.map((item) => Ayat.fromJson(item)).toList();
  } else {
    print("Gagal fetch: ${response.statusCode}");
    throw Exception('Gagal memuat ayat');
  }
}





  @override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: _surahList.length,
    child: Scaffold(
      appBar: AppBar(
        title: Text("Al-Qur'an"),
        backgroundColor: Color(0xFF1ABC9C),
        foregroundColor: Colors.white,
        bottom: isLoading || isError
            ? null
            : TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: _surahList
                    .map((surah) => Tab(text: surah.namaLatin))
                    .toList(),
              ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text("Gagal memuat data."))
              : TabBarView(
                  children: _surahList.map((surah) {
                    return FutureBuilder<List<Ayat>>(
                      future: fetchAyat(surah.nomor),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Gagal memuat ayat'));
                        } else {
                          final ayatList = snapshot.data!;
                          return ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: ayatList.length,
                            itemBuilder: (context, index) {
                              final ayat = ayatList[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${ayat.ar}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${ayat.idn}", // ✅ Ganti 'idn' dengan 'id'
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          );

                        }
                      },
                    );
                  }).toList(),
                ),
    ),
  );
}

}
