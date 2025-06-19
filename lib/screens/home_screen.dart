import 'package:flutter/material.dart';
import '../services/api_sholat_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
Map<String, dynamic>? jadwal;
bool isLoading = true;
bool isError = false;

@override
void initState() {
  super.initState();
  getJadwal();
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
