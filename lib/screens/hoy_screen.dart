
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/baseDatosForaneas.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/CitaConNombre.dart';

class HoyScreen extends StatefulWidget {
  const HoyScreen({super.key});

  @override
  State<HoyScreen> createState() => _HoyScreenState();
}

class _HoyScreenState extends State<HoyScreen> {
  List<CitaConNombre> _citasProximas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCitas();
  }

  Future<void> _cargarCitas() async {
    setState(() {
      _isLoading = true;
    });

    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    final citas = await DB.obtenerCitasConNombrePersona();

    final citasFiltradas = citas.where((cita) {
      try {
        final fechaCita = DateFormat('yyyy-MM-dd').parse(cita.fecha);
        return fechaCita.isAtSameMomentAs(hoy) || fechaCita.isAfter(hoy);
      } catch (e) {
        return false;
      }
    }).toList();


    citasFiltradas.sort((a, b) {
      final fechaA = DateFormat('yyyy-MM-dd HH:mm').parse('${a.fecha} ${a.hora}');
      final fechaB = DateFormat('yyyy-MM-dd HH:mm').parse('${b.fecha} ${b.hora}');
      return fechaA.compareTo(fechaB);
    });

    setState(() {
      _citasProximas = citasFiltradas;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximas Citas'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarCitas,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _citasProximas.isEmpty
              ? const Center(
                  child: Text(
                    'No tienes citas próximas.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _citasProximas.length,
                  itemBuilder: (context, index) {
                    final cita = _citasProximas[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMMMMEEEEd('es_ES').format(DateFormat('yyyy-MM-dd').parse(cita.fecha)),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                            const Divider(),
                            Text(
                              'con ${cita.nombrepersona}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(child: Text(cita.lugar, style: const TextStyle(fontSize: 16))),
                              ],
                            ),
                            const SizedBox(height: 8),
                             Row(
                              children: [
                                const Icon(Icons.access_time_filled_rounded, size: 18, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(cita.hora, style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            if (cita.anotaciones.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  'Anotaciones: ${cita.anotaciones}',
                                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
