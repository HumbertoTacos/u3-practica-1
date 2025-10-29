
import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/baseDatosForaneas.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/CitaConNombre.dart';
import 'package:u3_ejercicio2_tablasconforanea/screens/add_edit_cita_screen.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  List<CitaConNombre> _citas = [];

  @override
  void initState() {
    super.initState();
    _cargarCitas();
  }

  Future<void> _cargarCitas() async {
    final citas = await DB.obtenerCitasConNombrePersona();
    setState(() {
      _citas = citas;
    });
  }

  void _mostrarFormularioParaCita([CitaConNombre? cita]) async {
    final resultado = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditCitaScreen(cita: cita),
      ),
    );

    if (resultado == true) {
      _cargarCitas();
    }
  }

  Future<void> _eliminarCita(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Estás seguro de que quieres eliminar esta cita?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await DB.eliminarCita(id);
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Cita eliminada correctamente.')));
      _cargarCitas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas las Citas'),
        backgroundColor: Colors.indigo,
      ),
      body: _citas.isEmpty
          ? const Center(
              child: Text('Aún no tienes citas agendadas.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _citas.length,
              itemBuilder: (context, index) {
                final cita = _citas[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cita.nombrepersona,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(cita.lugar)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${cita.fecha} a las ${cita.hora}'),
                          ],
                        ),
                        if (cita.anotaciones.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Anotaciones: ${cita.anotaciones}', style: const TextStyle(fontStyle: FontStyle.italic)),
                          ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              label: const Text('Editar', style: TextStyle(color: Colors.blueAccent)),
                              onPressed: () => _mostrarFormularioParaCita(cita),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              label: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                              onPressed: () => _eliminarCita(cita.idcita!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioParaCita(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
