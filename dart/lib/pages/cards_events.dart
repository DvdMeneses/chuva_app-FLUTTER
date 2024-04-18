import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:from_css_color/from_css_color.dart';
import 'package:chuva_dart/database/database.dart';
import 'package:chuva_dart/pages/detalhes_evento.dart';

class CardEventos extends StatefulWidget {
  final String date;
  final AppDatabase database;
  const CardEventos({
    Key? key,
    required this.date,
    required this.database,
  }) : super(key: key);

  @override
  _CardEventosState createState() => _CardEventosState();
}

class _CardEventosState extends State<CardEventos> with RouteAware {
  late List<dynamic> catalogdata = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(widget.date);
  }

  Future<void> fetchData(String date) async {
    late String apiUrl;
    if (date == '2023-11-30') {
      apiUrl =
          'https://raw.githubusercontent.com/chuva-inc/exercicios-2023/master/dart/assets/activities-1.json';
    } else {
      apiUrl =
          'https://raw.githubusercontent.com/chuva-inc/exercicios-2023/master/dart/assets/activities.json';
    }

    var response = await http.get(Uri.parse(apiUrl));

    setState(() {
      _isLoading = true;
    });

    if (response.statusCode == 200) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isLoading = false;
          final jsonData = json.decode(response.body)['data'];
          catalogdata = jsonData.where((item) {
            final startDate = DateTime.parse(item['start']).toLocal();

            final itemDate = startDate.toString().substring(0, 10);
            return itemDate == date;
          }).map((item) {
            if (item['parent'] != null) {
              var parent = jsonData.firstWhere(
                  (parent) => parent['id'] == item['parent'],
                  orElse: () => null);
              if (parent != null) {
                item['parentName'] = parent['title']['pt-br'];
              }
            }
            return item;
          }).toList();
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  Future<bool> _isEventAdded(int id) async {
    var evento = await widget.database.eventoDao.findEventoById(id.toString());
    return evento != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? Image.network(
                'https://img1.picmix.com/output/stamp/normal/5/0/2/7/2447205_832fa.gif',
                // Aqui você pode substituir a URL do GIF desejado
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            : ListView.builder(
                itemCount: catalogdata.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = catalogdata[index];

                  var title = item['title']['pt-br'] ?? '';
                  var type = item['type']['title']['pt-br'] ?? '';
                  var color = item['category']['color'] ?? '';
                  var category = item["category"]["title"]["pt-br"] ?? '';
                  var personName = item['people'].isNotEmpty
                      ? item['people'][0]['name'] ?? ''
                      : '';
                  var description = item['description']['pt-br'];
                  var institution = item['people'].isNotEmpty
                      ? item['people'][0]['institution'] ?? ''
                      : '';
                  var location = item['locations'][0]['title']['pt-br'];
                  var categoryColor =
                      color.isNotEmpty ? fromCssColor(color) : Colors.black;
                  var start = DateTime.parse(item['start']).toLocal();
                  var end = DateTime.parse(item['end']).toLocal();
                  var startTime =
                      '${start.hour}:${start.minute.toString().padLeft(2, '0')}';
                  var endTime =
                      '${end.hour}:${end.minute.toString().padLeft(2, '0')}';
                  var dayOfWeek = _getDayOfWeek('$start');

                  var people = item['people'];
                  var parentName = item['parentName'];
                  // Filtrando eventos filhos
                  return FutureBuilder<bool>(
                    future: _isEventAdded(item['id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        bool _isEventAdded = snapshot.data ?? false;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalhesEventos(
                                  id: item['id'],
                                  cor: categoryColor.toCssString(),
                                  category: category,
                                  description: description,
                                  title: title,
                                  dayOfWeek: dayOfWeek,
                                  start: startTime,
                                  end: endTime,
                                  institution: institution,
                                  location: location,
                                  people: people ?? '',
                                  parentName: parentName,
                                  database: widget.database,
                                  childrenEvents: catalogdata
                                      .where((child) =>
                                          child['parent'] == item['id'])
                                      .toList(), // Filtrando eventos filhos
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: const Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: categoryColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 330,
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                type +
                                                    ' de ' +
                                                    startTime +
                                                    ' até ' +
                                                    endTime,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Expanded(child: SizedBox()),
                                              Icon(
                                                Icons.bookmark,
                                                color: _isEventAdded
                                                    ? Colors.grey
                                                    : Colors.transparent,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            personName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}

String _getDayOfWeek(String date) {
  final parsedDate = DateTime.parse(date);
  switch (parsedDate.weekday) {
    case DateTime.monday:
      return 'Segunda-feira';
    case DateTime.tuesday:
      return 'Terça-feira';
    case DateTime.wednesday:
      return 'Quarta-feira';
    case DateTime.thursday:
      return 'Quinta-feira';
    case DateTime.friday:
      return 'Sexta-feira';
    case DateTime.saturday:
      return 'Sábado';
    case DateTime.sunday:
      return 'Domingo';
    default:
      return '';
  }
}
