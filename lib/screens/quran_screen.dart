// quran_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
        final List<Surah> surahList =
            data.map((json) => Surah.fromJson(json)).toList();

        setState(() {
          _surahList = surahList;
          isLoading = false;
        });
      } else {
        throw Exception('Gagal fetch data: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

 @override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: _surahList.length,
    child: Scaffold(
      appBar: AppBar(
        title: Text("Al-Qur'an"),
        bottom: isLoading || isError
            ? null
            : TabBar(
                isScrollable: true,
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
                  children:
                      _surahList.map((_) => Center(child: Text("..."))).toList(),
                 ),
              ),
            );
          }
        }
