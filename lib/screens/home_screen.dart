import 'package:flutter/material.dart';
import '../services/api_sholat_service.dart';
import 'dart:async';
import 'package:phosphor_flutter/phosphor_flutter.dart';


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
    // Home, tidak perlu navigasi
    setState(() {
      _selectedIndex = index;
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Text(
                            "Tanggal: ${jadwal!['jadwal']['tanggal']}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Lokasi: ${jadwal!['lokasi']}",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 150),
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
                         
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF1ABC9C),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.house()),
            label: 'Home',
          ),
        ],
      ),
    );
  }
}
