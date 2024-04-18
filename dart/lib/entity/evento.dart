import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

@Entity(tableName: 'evento')
class Evento {
  @primaryKey
  final String id;

  Evento(this.id);
}
