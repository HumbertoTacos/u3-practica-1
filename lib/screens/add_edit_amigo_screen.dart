import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/Persona.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/baseDatosForaneas.dart';

class AddEditAmigoScreen extends StatefulWidget {
  final Persona? amigo;

  const AddEditAmigoScreen({super.key, this.amigo});

  @override
  State<AddEditAmigoScreen> createState() => _AddEditAmigoScreenState();
}

class _AddEditAmigoScreenState extends State<AddEditAmigoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _telefonoController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.amigo?.nombre ?? '');
    _telefonoController = TextEditingController(text: widget.amigo?.telefono ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _guardarAmigo() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final telefono = _telefonoController.text;

      if (widget.amigo == null) {
        // Crear nuevo amigo
        final nuevoAmigo = Persona(nombre: nombre, telefono: telefono);
        await DB.insertarPersona(nuevoAmigo);
      } else {
        // Actualizar amigo existente
        final amigoActualizado = Persona(nombre :nombre, telefono:telefono, IDPERSONA:  widget.amigo!.IDPERSONA);
        await DB.actualizarPersona(amigoActualizado);
      }

      Navigator.of(context).pop(true); // Devuelve true para indicar que se hizo un cambio
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.amigo == null ? 'Añadir Amigo' : 'Editar Amigo'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarAmigo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
