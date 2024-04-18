import 'package:chuva_dart/entity/evento.dart';
import 'package:floor/floor.dart';

@dao
abstract class EventoDao {
  @Query('SELECT * FROM Evento')
  Future<List<Evento>> findAllEvento();

  @Query('SELECT * FROM Evento WHERE id = :id')
  Future<Evento?> findEventoById(String id);

  @insert
  Future<void> insertEvento(Evento evento);

  @delete
  Future<void> deleteEventoById(Evento evento);
}
