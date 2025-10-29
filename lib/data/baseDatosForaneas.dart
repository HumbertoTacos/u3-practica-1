
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Persona.dart';
import 'Cita.dart';
import 'CitaConNombre.dart';

class DB {
  static Future<Database> _conectarDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'ejercicio2.db'),
      version: 1,
      onConfigure: (db) {
        return db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE PERSONA( IDPERSONA INTEGER PRIMARY KEY AUTOINCREMENT, NOMBRE TEXT, TELEFONO TEXT)");
        await db.execute("CREATE TABLE CITA( IDCITA INTEGER PRIMARY KEY AUTOINCREMENT, LUGAR TEXT, FECHA TEXT, HORA TEXT, ANOTACIONES TEXT,  IDPERSONA INTEGER, FOREIGN KEY(IDPERSONA) REFERENCES PERSONA(IDPERSONA) ON DELETE CASCADE ON UPDATE CASCADE)");
      },
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
        IDPERSONA: maps[i]['IDPERSONA'],
        nombre: maps[i]['NOMBRE'],
        telefono: maps[i]['TELEFONO'],
      );
    });
  }

  static Future<List<Cita>> obtenerCitas() async {
    final db = await DB._conectarDB();
    final List<Map<String, dynamic>> maps = await db.query('CITA');
    return List.generate(maps.length, (i) {
      return Cita(
        idcita: maps[i]['IDCITA'],
        lugar: maps[i]['LUGAR'],
        fecha: maps[i]['FECHA'],
        hora: maps[i]['HORA'],
        anotaciones: maps[i]['ANOTACIONES'],
        idpersona: maps[i]['IDPERSONA'],
      );
    });
  }

  static Future<List<CitaConNombre>> obtenerCitasConNombrePersona() async {
    final db = await DB._conectarDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT C.IDCITA, C.LUGAR, C.FECHA, C.HORA, C.ANOTACIONES, C.IDPERSONA, P.NOMBRE AS NOMBREPERSONA '
        'FROM CITA C '
        'INNER JOIN PERSONA P ON C.IDPERSONA = P.IDPERSONA');

    return List.generate(maps.length, (i) {
      return CitaConNombre(
        idcita: maps[i]['IDCITA'],
        lugar: maps[i]['LUGAR'],
        fecha: maps[i]['FECHA'],
        hora: maps[i]['HORA'],
        anotaciones: maps[i]['ANOTACIONES'],
        idpersona: maps[i]['IDPERSONA'],
        nombrepersona: maps[i]['NOMBREPERSONA'],
      );
    });
  }

  static Future<void> eliminarPersona(int id) async {
    final db = await DB._conectarDB();
    await db.delete('PERSONA', where: 'IDPERSONA = ?', whereArgs: [id]);
  }

  static Future<void> eliminarCita(int id) async {
    final db = await DB._conectarDB();
    await db.delete('CITA', where: 'IDCITA = ?', whereArgs: [id]);
  }

  static Future<void> actualizarPersona(Persona p) async {
    final db = await DB._conectarDB();
    await db.update('PERSONA', p.toJSON(), where: 'IDPERSONA = ?', whereArgs: [p.IDPERSONA]);
  }

  static Future<void> actualizarCita(Cita c) async {
    final db = await DB._conectarDB();
    await db.update('CITA', c.toJSON(), where: 'IDCITA = ?', whereArgs: [c.idcita]);
  }
}
