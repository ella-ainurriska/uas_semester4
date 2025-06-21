class Ayat {
  final int no;
  final String ar;
  final String idn;

  Ayat({
    required this.no,
    required this.ar,
    required this.idn,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      no: json['nomor'], // Sesuaikan dengan nama field di API
      ar: json['ar'],
      idn: json['idn'],
    );
  }
}
