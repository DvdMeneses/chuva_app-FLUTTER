// database.dart

// required package imports
import 'dart:async';
import 'package:chuva_dart/dao/evento_dao.dart';
import 'package:chuva_dart/entity/evento.dart';
import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Evento])
abstract class AppDatabase extends FloorDatabase {
  EventoDao get eventoDao;
}
