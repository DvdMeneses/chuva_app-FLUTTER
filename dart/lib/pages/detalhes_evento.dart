import 'package:chuva_dart/entity/evento.dart';
import 'package:chuva_dart/main.dart';
import 'package:chuva_dart/widgets/card_evento.dart';
import 'package:chuva_dart/pages/detalhes_person.dart';

import 'package:flutter/material.dart';

import 'package:from_css_color/from_css_color.dart';
import 'package:chuva_dart/database/database.dart';

class DetalhesEventos extends StatefulWidget {
  final int id;
  final String? cor;
  final String title;
  final String? category;
  final String? description;
  final String dayOfWeek;
  final String start;
  final String end;
  final List<dynamic> people;
  final String? institution;
  final String? location;
  final String? parentName;
  final AppDatabase database;
  final List<dynamic> childrenEvents; // Lista de eventos filho

  const DetalhesEventos({
    Key? key,
    required this.id,
    required this.cor,
    required this.title,
    required this.category,
    required this.description,
    required this.dayOfWeek,
    required this.start,
    required this.end,
    required this.people,
    this.institution,
    this.location,
    this.parentName,
    required this.database,
    required this.childrenEvents,
  }) : super(key: key);

  @override
  _DetalhesEventosState createState() => _DetalhesEventosState();
}

class _DetalhesEventosState extends State<DetalhesEventos> {
  bool _isEventAdded = false;

  @override
  void initState() {
    super.initState();
    _checkEventStatus();
  }

  void _checkEventStatus() async {
    var evento = await widget.database.eventoDao.findEventoById('${widget.id}');
    setState(() {
      _isEventAdded = evento != null;
    });
  }

  void _toggleEventAdded() async {
    String message;
    if (_isEventAdded) {
      await widget.database.eventoDao.deleteEventoById(Evento('${widget.id}'));
      message = 'Não vamos mais  te lembrar dessa atividade.';
    } else {
      Evento novoEvento = Evento('${widget.id}');
      await widget.database.eventoDao.insertEvento(novoEvento);
      message = 'Vamos te lembrar dessa atividade.';
    }
    _showSnackBar(message);
    setState(() {
      _isEventAdded = !_isEventAdded;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Defina a duração desejada
      ),
    );
  }

  String _parseDescription(String? description) {
    if (description == null) {
      return '';
    }

    String cleanedDescription = description.replaceAll(RegExp(r'<div.*?>'), '');
    cleanedDescription = cleanedDescription.replaceAll(RegExp(r'</div>'), '');
    cleanedDescription = cleanedDescription.replaceAll('<p>', '');
    List<String> paragraphs = cleanedDescription.split('</p>');
    String parsedDescription = paragraphs.join('\n');

    return parsedDescription;
  }

  Widget _buildPersonCard(String name, String? pictureUrl, String institution,
      dynamic personDetails) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesPerson(
              people: personDetails,
              name: name.toString(),
              database: widget.database,
              childrenEvents: widget.childrenEvents,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius:
                        pictureUrl != null && pictureUrl.isNotEmpty ? 30 : 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: pictureUrl != null && pictureUrl.isNotEmpty
                        ? NetworkImage(pictureUrl)
                        : null,
                    child: pictureUrl == null || pictureUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 40,
                          )
                        : null,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        institution,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 69, 97, 137),
        elevation: 8,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50.0),
              child: Text(
                "Chuva 💜 Flutter",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          iconSize: 32,
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyApp(
                    database: widget.database,
                  ),
                ),
              );
            });
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  color: widget.cor != null
                      ? fromCssColor(widget.cor!)
                      : Colors.black,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      '${widget.category}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.parentName != null && widget.parentName!.isNotEmpty)
                Container(
                  color: Color.fromARGB(255, 48, 109, 195),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        // Envolve o Row com o Expanded
                        child: Text(
                          'Essa atividade é parte de "${widget.parentName}"',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          softWrap:
                              true, // Permite que o texto quebre automaticamente
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 27),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Text(
                  ' ${widget.title}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Color.fromARGB(255, 48, 109, 195),
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.dayOfWeek,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const Text(
                            ' - ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            widget.start,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const Text(
                            ' - ',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${widget.end}',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color.fromARGB(255, 48, 109, 195),
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.location != null
                                ? '${widget.location}'
                                : 'Não temos a localização desse evento',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ElevatedButton.icon(
                  onPressed: _toggleEventAdded,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 48, 109, 195),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  icon: Icon(
                    _isEventAdded ? Icons.star : Icons.star_border_sharp,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isEventAdded
                        ? 'Remover da sua agenda'
                        : 'Adicionar à sua agenda',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  '${_parseDescription(widget.description)}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.people.isNotEmpty &&
                          widget.people[0]['role']['label']['pt-br'] != null
                      ? '${widget.people[0]['role']['label']['pt-br']}'
                      : ' ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (var person in widget.people)
                _buildPersonCard(person['name'] ?? '', person['picture'] ?? '',
                    person['institution'] ?? '', widget.people),
              _buildChildrenEvents(widget.childrenEvents),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildrenEvents(List<dynamic> childrenEvents) {
    if (childrenEvents.isEmpty) {
      return SizedBox
          .shrink(); // Retorna um widget vazio se não houver eventos filhos
    }

    List<Widget> eventCards = [];

    // Adicionando o título "Eventos Relacionados"
    eventCards.add(
      Padding(
        padding: EdgeInsets.only(left: 20.0, bottom: 15),
        child: Text(
          'Sub-atividades',
          style: TextStyle(
            fontSize: 17,
            color: Colors.grey,
          ),
        ),
      ),
    );

    // Adicionando os cards de evento
    for (var event in childrenEvents) {
      final start = DateTime.parse(event['start']).toLocal();
      final end = DateTime.parse(event['end']).toLocal();
      final startTime =
          '${start.hour}:${start.minute.toString().padLeft(2, '0')}';
      final endTime = '${end.hour}:${end.minute.toString().padLeft(2, '0')}';
      eventCards.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: cardEvento(
              event['category']['color'] ?? '',
              event['type']['title']['pt-br'] ?? '',
              startTime,
              endTime,
              event['title']['pt-br'] ?? '',
              event['people'][0]['name'] ?? '',
              event['people'][1]['name'] ?? ''),
        ),
      );
    }

    // Retornando os cards de evento em um único Column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: eventCards,
    );
  }

  String _getFormattedDate(DateTime date) {
    final dayOfWeek = _getDayOfWeek(date);
    return '$dayOfWeek, ${date.day}/${date.month}/${date.year}';
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'seg.';
      case DateTime.tuesday:
        return 'ter.';
      case DateTime.wednesday:
        return 'qua.';
      case DateTime.thursday:
        return 'qui.';
      case DateTime.friday:
        return 'sex.';
      case DateTime.saturday:
        return 'sab.';
      case DateTime.sunday:
        return 'dom.';
      default:
        return '';
    }
  }
}
