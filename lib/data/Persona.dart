

class Persona{
  Map<String, dynamic> toJSON(){
    return {
      'IDPERSONA': IDPERSONA ,
      'NOMBRE': nombre,
      'TELEFONO': telefono,
    };
  }
  String IDPERSONA;
  String nombre;
  String telefono;
  Persona(this.nombre, this.telefono, this.IDPERSONA);
  }
