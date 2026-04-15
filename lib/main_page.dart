import 'package:flutter/material.dart';
import 'package:ruang_rasa_mobile/app/modules/home/views/home_view.dart';
import 'package:ruang_rasa_mobile/app/modules/product/views/product_view.dart';
import 'package:ruang_rasa_mobile/app/modules/profile/views/profile_view.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    ProductView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF004643), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: Color(0xFFFBBF24),
          unselectedItemColor: Colors.white70,

          showUnselectedLabels: true,

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
