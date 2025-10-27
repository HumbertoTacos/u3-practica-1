
class Cita{
  Map<String, dynamic> toJSON(){
    return {
      'IDCITA': IDCITA ,
      'LUGAR': lugar,
      'FECHA': fecha,
      'HORA': hora,
      'ANOTACIONES': anotaciones,
      'IDPERSONA': IDPERSONA,
    };


  }
  String IDCITA;
  String lugar;
  String fecha;
  String hora;
  String anotaciones;
  String IDPERSONA;
  Cita(this.lugar, this.fecha, this.hora, this.anotaciones, this.IDPERSONA, this.IDCITA);
}