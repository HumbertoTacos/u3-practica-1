
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/Cita.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/Persona.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/baseDatosForaneas.dart';
import 'package:u3_ejercicio2_tablasconforanea/data/CitaConNombre.dart';

class AddEditCitaScreen extends StatefulWidget {
  final CitaConNombre? cita;

  const AddEditCitaScreen({super.key, this.cita});

  @override
  State<AddEditCitaScreen> createState() => _AddEditCitaScreenState();
}

class _AddEditCitaScreenState extends State<AddEditCitaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lugarController;
  late TextEditingController _anotacionesController;
  DateTime _fechaSeleccionada = DateTime.now();
  TimeOfDay _horaSeleccionada = TimeOfDay.now();
  
  List<Persona> _amigos = [];
  int? _amigoSeleccionadoId;

  @override
  void initState() {
    super.initState();
    _lugarController = TextEditingController(text: widget.cita?.lugar ?? '');
    _anotacionesController = TextEditingController(text: widget.cita?.anotaciones ?? '');
    
    if (widget.cita != null) {
      try {
        _fechaSeleccionada = DateFormat('yyyy-MM-dd').parse(widget.cita!.fecha);
        final timeParts = widget.cita!.hora.split(':');
        _horaSeleccionada = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      } catch (e) {
        _fechaSeleccionada = DateTime.now();
        _horaSeleccionada = TimeOfDay.now();
      }
      _amigoSeleccionadoId = widget.cita!.idpersona;
    }
    _cargarAmigos();
  }

  Future<void> _cargarAmigos() async {
    final amigos = await DB.obtenerPersonas();
    setState(() {
      _amigos = amigos;
      if (widget.cita == null && amigos.isNotEmpty) {
        _amigoSeleccionadoId = amigos.first.IDPERSONA;
      }
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada,
    );
    if (picked != null && picked != _horaSeleccionada) {
      setState(() {
        _horaSeleccionada = picked;
      });
    }
  }

  void _guardarCita() async {
    if (_formKey.currentState!.validate() && _amigoSeleccionadoId != null) {
      final fechaFormateada = DateFormat('yyyy-MM-dd').format(_fechaSeleccionada);
      final horaFormateada = '${_horaSeleccionada.hour.toString().padLeft(2, '0')}:${_horaSeleccionada.minute.toString().padLeft(2, '0')}';

      final cita = Cita(
        lugar: _lugarController.text,
        fecha: fechaFormateada,
        hora: horaFormateada,
        anotaciones: _anotacionesController.text,
        idpersona: _amigoSeleccionadoId!,
        idcita: widget.cita?.idcita,
      );

      if (widget.cita == null) {
        await DB.insertarCita(cita);
      } else {
        await DB.actualizarCita(cita);
      }

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cita == null ? 'Agendar Cita' : 'Editar Cita'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _amigos.isEmpty
                  ? const Text('Cargando amigos...')
                  : DropdownButtonFormField<int>(
                      value: _amigoSeleccionadoId,
                      items: _amigos.map((persona) {
                        return DropdownMenuItem<int>(
                          value: persona.IDPERSONA,
                          child: Text(persona.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _amigoSeleccionadoId = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Amigo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null ? 'Debes seleccionar un amigo' : null,
                    ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lugarController,
                decoration: const InputDecoration(
                  labelText: 'Lugar',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) => value == null || value.isEmpty ? 'El lugar no puede estar vacío' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text('Fecha: ${DateFormat.yMd().format(_fechaSeleccionada)}'),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Seleccionar'),
                    onPressed: () => _seleccionarFecha(context),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Hora: ${_horaSeleccionada.format(context)}'),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: const Text('Seleccionar'),
                    onPressed: () => _seleccionarHora(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _anotacionesController,
                decoration: const InputDecoration(
                  labelText: 'Anotaciones',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _guardarCita,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Cita'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _lugarController.dispose();
    _anotacionesController.dispose();
    super.dispose();
  }
}
