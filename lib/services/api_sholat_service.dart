import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coba3/models/ayat_model.dart';

class SholatService {
  static Future<List<Ayat>> fetchAyat(int nomorSurah) async {
    final url = 'https://equran.id/api/surat/$nomorSurah';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List ayatJson = jsonData['ayat'];
      return ayatJson.map((item) => Ayat.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat ayat');
    }
  }
  static Future<Map<String, dynamic>> fetchJadwal() async {
    final now = DateTime.now();
    final String tanggal = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final response = await http.get(
      Uri.parse("https://api.myquran.com/v2/sholat/jadwal/1619/$tanggal"),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        return jsonData['data']; // <== INI PENTING!
      } else {
        throw Exception('Status false dari API');
      }
    } else {
      print('Status Code: ${response.statusCode}');
      throw Exception('Gagal mengambil data jadwal');
    }
  }
}
