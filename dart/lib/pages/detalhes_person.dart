import 'dart:convert';
import 'package:chuva_dart/database/database.dart';
import 'package:chuva_dart/widgets/card_evento.dart';
import 'package:chuva_dart/pages/detalhes_evento.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DetalhesPerson extends StatefulWidget {
  final List<dynamic> people;
  final String name;
  final AppDatabase database;
  final List<dynamic> childrenEvents;

  DetalhesPerson({
    Key? key,
    required this.people,
    required this.name,
    required this.database,
    required this.childrenEvents,
  }) : super(key: key);

  @override
  _DetalhesPersonState createState() => _DetalhesPersonState();
}

class _DetalhesPersonState extends State<DetalhesPerson> {
  List<dynamic> events = []; // Lista para armazenar os eventos encontrados

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Chama a função para buscar os eventos
  }

  Future<void> fetchEvents() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/chuva-inc/exercicios-2023/master/dart/assets/activities.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> fetchedEvents = data['data'];
      setState(() {
        events = fetchedEvents;
      });
    } else {
      throw Exception('Failed to load events');
    }
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
            Navigator.pop(context);
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
              for (var person in widget.people)
                if (person['name'] == widget.name)
                  _buildPersonCard(
                    person['name'] ?? '',
                    person['picture'] ?? '',
                    person['institution'] ?? '',
                    person['bio']['pt-br'] ?? '',
                  ),
              SizedBox(height: 20), // Espaçamento entre os cards e a bio
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Atividades',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                  height:
                      10), // Espaçamento entre o texto "Atividades" e os cards
              if (events.isNotEmpty) ...[
                _buildEventDate(events.first),
                for (var event in events)
                  if (event['people']
                      .any((person) => person['name'] == widget.name))
                    _buildEventCard(event),
              ],
              SizedBox(height: 20), // Espaçamento entre os eventos e o rodapé
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonCard(
    String name,
    dynamic pictureUrl,
    dynamic institution,
    dynamic bio,
  ) {
    String initials = _extractInitials(name); // Extrai as iniciais do nome

    Widget avatar;
    if (pictureUrl is String && pictureUrl.trim().isEmpty) {
      // Se a foto da pessoa for uma string vazia, exibe um círculo com as iniciais dentro
      avatar = CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 48, 109, 195),
        radius: 60,
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 44,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      // Caso contrário, exibe a imagem da pessoa no CircleAvatar
      avatar = CircleAvatar(
        radius: pictureUrl is String && pictureUrl.isNotEmpty ? 50 : 50,
        backgroundColor: Colors.transparent,
        backgroundImage: pictureUrl is String && pictureUrl.isNotEmpty
            ? NetworkImage(pictureUrl)
            : null,
        child: !(pictureUrl is String && pictureUrl.isNotEmpty)
            ? const Icon(
                Icons.person,
                color: Colors.grey,
                size: 40,
              )
            : null,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                    avatar, // Usa o avatar construído acima
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        if (institution is String) SizedBox(height: 1),
                        Text(
                          '$institution',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
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
        SizedBox(height: 15), // Espaçamento entre o card e a bio
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Bio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            _parseDescription(bio),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 20), // Espaçamento entre a bio e os eventos
      ],
    );
  }

  Widget _buildEventDate(dynamic event) {
    final start = DateTime.parse(event['start']).toLocal();
    final formattedDate = _getFormattedDate(start);

    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Text(
        formattedDate,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildEventCard(dynamic event) {
    final start = DateTime.parse(event['start']).toLocal();
    final end = DateTime.parse(event['end']).toLocal();
    final startTime =
        '${start.hour}:${start.minute.toString().padLeft(2, '0')}';
    final endTime = '${end.hour}:${end.minute.toString().padLeft(2, '0')}';

    String personName = widget.name;
    String personName2 =
        event['people'].length > 1 ? event['people'][1]['name'] ?? '' : '';

    return GestureDetector(
      onTap: () {
        var title = event['title']['pt-br'] ?? '';

        var color = event['category']['color'] ?? '';
        var category = event["category"]["title"]["pt-br"] ?? '';

        var description = event['description']['pt-br'];
        var institution = event['people'].isNotEmpty
            ? event['people'][0]['institution'] ?? ''
            : '';
        var location = event['locations'][0]['title']['pt-br'];
        var people = event['people'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesEventos(
                id: event[
                    'id'], // Supondo que 'id' seja a identificação do evento
                cor: color,
                title: title,
                category: category,
                description: description,
                dayOfWeek: _getDayOfWeek(start),
                start: startTime,
                end: endTime,
                people: people,
                institution: institution,
                location: location,
                database: widget.database,
                childrenEvents: widget.childrenEvents),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: cardEvento(
            event['category']['color'],
            event['type']['title']['pt-br'],
            startTime,
            endTime,
            event['title']['pt-br'],
            personName,
            personName2),
      ),
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

  String _parseDescription(String? description) {
    if (description == null) {
      return '';
    }

    // Remover as tags HTML
    String cleanedDescription = description.replaceAll(RegExp(r'<.*?>'), '');

    return cleanedDescription;
  }

  String _extractInitials(String fullName) {
    // Divide o nome completo em palavras
    List<String> words = fullName.split(' ');

    // Inicializa as iniciais vazias
    String initials = '';

    // Adiciona a primeira letra de cada palavra ao texto de iniciais
    for (var word in words) {
      if (word.isNotEmpty) {
        initials +=
            word[0].toUpperCase(); // Adiciona a primeira letra em maiúscula
      }
    }

    return initials;
  }
}
