import 'package:flutter/material.dart';
import '../services/api_sholat_service.dart';
import 'dart:async';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'quran_screen.dart';
import 'kalender_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? jadwal;
  bool isLoading = true;
  bool isError = false;

  String _currentTime = '';
  late Timer _timer;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentTime();
    _startTimer();
    getJadwal();
  }

  void _getCurrentTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _getCurrentTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> getJadwal() async {
    try {
      final data = await SholatService.fetchJadwal();
      setState(() {
        jadwal = data;
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

// int _selectedIndex = 0;

void _onItemTapped(int index) async {
  if (index == 0) {
    // Home
    setState(() {
      _selectedIndex = index;
    });
  } else if (index == 1) {
    // Kalender
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KalenderScreen()),
    );
    setState(() {
      _selectedIndex = 0; // kembali ke Home
    });
  }
}


  @override
Widget build(BuildContext context) {
  final halfHeight = MediaQuery.of(context).size.height * 0.5;

  return Scaffold(
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : isError
            ? Center(child: Text('Gagal memuat jadwal sholat.'))
            : Stack(
                children: [
                  Container(
                    height: halfHeight,
                    color: Color(0xFF1ABC9C),
                  ),
                  Positioned(
                  bottom: halfHeight - 80,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.2, 
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.2), 
                        BlendMode.srcATop,
                      ),
                      child: Image.asset(
                        'assets/images/baground.png',
                        fit: BoxFit.cover,
                        height: 130,
                      ),
                    ),
                  ),
                ),

                  SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal: ${jadwal!['jadwal']['tanggal']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Lokasi: ${jadwal!['lokasi']}",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 60),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  _currentTime,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Waktu sekarang",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildWaktuTile('Subuh',
                                      jadwal!['jadwal']['subuh'], PhosphorIcons.sunHorizon()),
                                  SizedBox(width: 25),
                                  _buildWaktuTile('Dzuhur',
                                      jadwal!['jadwal']['dzuhur'], PhosphorIcons.sun()),
                                  SizedBox(width: 25),
                                  _buildWaktuTile('Ashar',
                                      jadwal!['jadwal']['ashar'], PhosphorIcons.cloudSun()),
                                  SizedBox(width: 25),
                                  _buildWaktuTile('Maghrib',
                                      jadwal!['jadwal']['maghrib'], PhosphorIcons.mountains()),
                                  SizedBox(width: 25),
                                  _buildWaktuTile('Isya',
                                      jadwal!['jadwal']['isya'], PhosphorIcons.moon()),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ngaji online",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  {
                                    'title': 'Ngaji Subuh Ust. Adi Hidayat',
                                    'url': 'https://youtu.be/r5DHnodVqz8?si=POun4lhIBQ_V9hL1',
                                  },
                                  {
                                    'title': 'Kajian Islam Ust. Hanan Attaki',
                                    'url': 'https://youtu.be/sX-kePnlgy4?si=YN2AbFqduL8t0vlE',
                                  },
                                  {
                                    'title': 'Ngaji Kitab Kuning KH. Bahauddin Nursalim',
                                    'url': 'https://youtu.be/10bxaEeU2C4?si=fJEbItOEiMXW_vom',
                                  },
                                  {
                                    'title': 'Ngaji Malam KH. Zainuddin MZ',
                                    'url': 'https://youtu.be/YzV3GBb_1IM?si=IW8e9fJsk2QoHIrF',
                                  },
                                ].map((video) {
                                  final videoId = YoutubePlayer.convertUrlToId(video['url']!);
                                  if (videoId == null) return SizedBox.shrink();

                                  return Container(
                                    width: 300,
                                    margin: EdgeInsets.only(right: 16),
                                    child: Column(
                                      children: [
                                        YoutubePlayer(
                                          controller: YoutubePlayerController(
                                            initialVideoId: videoId,
                                            flags: YoutubePlayerFlags(
                                              autoPlay: false,
                                              mute: false,
                                            ),
                                          ),
                                          showVideoProgressIndicator: true,
                                          progressIndicatorColor: Color(0xFF1ABC9C),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          video['title']!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            SizedBox(height: 20),
                          ],
                        ),
                      ),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QuranScreen()),
                );
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Color(0xFF1ABC9C),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.bookOpenText(PhosphorIconsStyle.bold),
                      color: Colors.white,
                      size: 26,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Qur\'an',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),

              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 8.0,
              elevation: 8, // tambahkan ini agar ada bayangan
              child: SizedBox(
                height: 60, // atur tinggi agar tidak overflow
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed, // ini penting!
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  selectedItemColor: Colors.grey,
                  unselectedItemColor: Colors.grey,
                  selectedLabelStyle: TextStyle(fontSize: 12),
                  unselectedLabelStyle: TextStyle(fontSize: 10),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(PhosphorIcons.house()),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(PhosphorIcons.calendarBlank()),
                      label: 'Kalender',
                    ),
                  ],
                ),
              ),
            ),

            );
          }


  Widget _buildWaktuTile(String label, String waktu, PhosphorIconData icon) {
    return Column(
      children: [
        Text(
          label,
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        SizedBox(height: 8),
        Icon(icon, color: Colors.white, size: 20),
        SizedBox(height: 15),
        Text(
          waktu,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  
}
