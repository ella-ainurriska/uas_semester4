class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final String tempatTurun;
  final int jumlahAyat;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.tempatTurun,
    required this.jumlahAyat,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: int.tryParse(json['number'] ?? '0') ?? 0,
      nama: json['name_short'] ?? '',
      namaLatin: json['name_id'] ?? '',
      jumlahAyat: int.tryParse(json['number_of_verses'] ?? '0') ?? 0,
      tempatTurun: json['revelation_id'] ?? '',
    );
  }
}
