import 'package:flutter/material.dart';
import '../services/api_sholat_service.dart';
import 'dart:async';


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
void initState() {
  super.initState();
  _getCurrentTime();
  _startTimer();
  getJadwal();
}

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}


  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? Center(child: CircularProgressIndicator())
        : isError
        ? Center(child: Text('Gagal memuat jadwal sholat.'))
        : Center(
            child: Text("Subuh: ${jadwal!['jadwal']['subuh']}"),
          ),

      appBar: AppBar(
        title: Text('Aplikasi Sholat'),
        backgroundColor: Color(0xFF1ABC9C),
      )
      body: Center(child: Text('Home Screen')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF1ABC9C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          
        ],
      ),
    );
  }
}
