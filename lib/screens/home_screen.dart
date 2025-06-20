import 'package:flutter/material.dart';
import '../services/api_sholat_service.dart';
import 'dart:async';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'quran_screen.dart';

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
    // Quran
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuranScreen()),
    );
    setState(() {
      _selectedIndex = 0; // kembali ke home setelah balik
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
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QuranScreen()),
                  );
                },
                backgroundColor: Color(0xFF1ABC9C),
                child: Icon(
                  PhosphorIcons.bookOpenText(PhosphorIconsStyle.bold),
                  color: Colors.white,
                  size: 32,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
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
