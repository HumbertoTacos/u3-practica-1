

class Persona{
  Map<String, dynamic> toJSON(){
    return {
      'IDPERSONA': IDPERSONA ,
      'NOMBRE': nombre,
      'TELEFONO': telefono,
    };
  }
  int ? IDPERSONA;
  String nombre;
  String telefono;
  Persona({required this.nombre, required this.telefono, this.IDPERSONA});
  }
