import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/baseDatosForaneas.dart';



class App_citas_ extends StatefulWidget {
  const App_citas_({super.key});

  @override
  State<App_citas_> createState() => _App_citas_State();
}

class _App_citas_State extends State<App_citas_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
      ),
      body: Center()
    );
  }
}
