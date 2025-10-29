import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablasconforanea/screens/amigos_screen.dart';
import 'package:u3_ejercicio2_tablasconforanea/screens/citas_screen.dart';
import 'package:u3_ejercicio2_tablasconforanea/screens/hoy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HoyScreen(),
    CitasScreen(),
    AmigosScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Hoy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}
