import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Persona.dart';
import 'Cita.dart';

class DB {
  static Future<Database> _conectarDB() async{ //esta linea sirve para conectar la base de datos
    return openDatabase( //esta linea sirve para abrir la base de datos
      join(await getDatabasesPath(), 'ejercicio2.db'),//esta linea sirve para crear la base de datos
      version: 1, //esta linea sirve para crear la version de la base de datos
      onConfigure: (db){
        return db.execute('PRAGMA foreign_keys = ON'); //esta linea sirve para habilitar las llaves foraneas en la base de datos
      }, //esta linea sirve para configurar la base de datos
      onCreate: (db, version) async{
        await db.execute("CREATE TABLE PERSONA( IDPERSONA INTEGER PRIMARY KEY AUTOINCREMENT, NOMBRE TEXT, TELEFONO TEXT)");
        await db.execute("CREATE TABLE CITA( IDCITA INTEGER PRIMARY KEY AUTOINCREMENT, LUGAR TEXT, FECHA TEXT, HORA TEXT,  IDPERSONA INTEGER, FOREIGN KEY(IDPERSONA) REFERENCES PERSONA(IDPERSONA) ON DELETE CASCADE ON UPDATE CASCADE)");
      } ,//esta linea sirve para crear la tabla de la base de datos
    );
  }

  static Future<int> insertarPersona(Persona p) async {
    final db = await DB._conectarDB();
    return await db.insert('PERSONA', p.toJSON());

  }

  static Future<int> insertarCita(Cita c) async {
    final db = await DB._conectarDB();
    return await db.insert('CITA', c.toJSON());

  }
  static Future<List<Persona>> obtenerPersonas() async {
    final db = await DB._conectarDB();
    final List<Map<String, dynamic>> maps = await db.query('PERSONA');
    return List.generate(maps.length, (i) {
      return Persona(
        maps[i]['NOMBRE'],
        maps[i]['TELEFONO'],
        maps[i]['IDPERSONA'],
      );
    });
  }

  static Future<List<Cita>> obtenerCitas() async {
  final db = await DB._conectarDB();
  final List<Map<String, dynamic>> maps = await db.query('CITA');
  return List.generate(maps.length, (i) {
    return Cita(
      maps[i]['LUGAR'],
      maps[i]['FECHA'],
      maps[i]['HORA'],
      maps[i]['ANOTACIONES'],
      maps[i]['IDPERSONA'],
      maps[i]['IDCITA'],
    );
  });
}

  static Future<void> eliminarPersona(int id) async {
  final db = await DB._conectarDB();
  final rowsDeleted = await db.delete('PERSONA', where: 'IDPERSONA = ?', whereArgs: [id]);
  print('Eliminados $rowsDeleted');
}

  static Future<void> eliminarCita(int id) async {
    final db = await DB._conectarDB();
    final rowsDeleted = await db.delete(
        'CITA', where: 'IDCITA = ?', whereArgs: [id]);
    print('Eliminados $rowsDeleted');
  }

  static Future<void> actualizarPersona(Persona p) async {
    final db = await DB._conectarDB();
    await db.update('PERSONA', p.toJSON(), where: 'IDPERSONA = ?', whereArgs: [p.IDPERSONA]);
  }

  static Future<void> actualizarCita(Cita c) async {
    final db = await DB._conectarDB();
    await db.update(
        'CITA', c.toJSON(), where: 'IDCITA = ?', whereArgs: [c.IDCITA]);
  }


}


