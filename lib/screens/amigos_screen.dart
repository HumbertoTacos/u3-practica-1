import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/baseDatosForaneas.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/Persona.dart';
import 'package:u3_ejercicio2_tablasconforanea/screens/add_edit_amigo_screen.dart';

class AmigosScreen extends StatefulWidget {
  const AmigosScreen({super.key});

  @override
  State<AmigosScreen> createState() => _AmigosScreenState();
}

class _AmigosScreenState extends State<AmigosScreen> {
  List<Persona> _amigos = [];

  @override
  void initState() {
    super.initState();
    _cargarAmigos();
  }

  Future<void> _cargarAmigos() async {
    final amigos = await DB.obtenerPersonas();
    setState(() {
      _amigos = amigos;
    });
  }

  void _mostrarFormularioParaAmigo([Persona? amigo]) async {
    final resultado = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditAmigoScreen(amigo: amigo),
      ),
    );

    if (resultado == true) {
      _cargarAmigos();
    }
  }

  Future<void> _eliminarAmigo(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Estás seguro de que quieres eliminar a este amigo? Se borrarán también todas sus citas asociadas.'),
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
      await DB.eliminarPersona(id);
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Amigo eliminado correctamente.')));
      _cargarAmigos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Amigos'),
        backgroundColor: Colors.teal,
      ),
      body: _amigos.isEmpty
          ? const Center(
              child: Text('Aún no tienes amigos. ¡Añade uno!', style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : ListView.builder(
              itemCount: _amigos.length,
              itemBuilder: (context, index) {
                final amigo = _amigos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(amigo.nombre.isNotEmpty ? amigo.nombre[0] : '?', style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(amigo.nombre),
                    subtitle: Text(amigo.telefono),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _mostrarFormularioParaAmigo(amigo),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _eliminarAmigo(amigo.IDPERSONA!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioParaAmigo(),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
