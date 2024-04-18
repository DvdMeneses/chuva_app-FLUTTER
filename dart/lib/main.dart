import 'package:chuva_dart/database/database.dart';

import 'package:chuva_dart/widgets/card_sobre.dart';

import 'package:chuva_dart/pages/cards_events.dart';
import 'package:chuva_dart/widgets/dia_tab.dart';
import 'package:chuva_dart/widgets/mes_ano.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(
    database: database,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.database}) : super(key: key);

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChuvaApp',
        home: MyHomePage(
          title: 'ChuvaApp',
          database: database,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.database})
      : super(key: key);

  final AppDatabase database;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 1);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
              padding: EdgeInsets.only(left: 108.0),
              child: Text(
                "Chuva 💜 Flutter",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 124.0),
              child: Text(
                "Programação",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Column(
            children: [
              SizedBox(height: 8),
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Stack(
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Exibindo todas atividades',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 90),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 5,
                      bottom: 5,
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 48, 109, 195),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.calendar_month_outlined),
                          onPressed: () {},
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.white,
                height: 1,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 48, 109, 195),
            child: Column(
              children: [
                TabBar(
                  isScrollable: false,
                  controller: _tabController,
                  labelPadding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 0.0),
                  indicatorColor: Color.fromARGB(255, 69, 97, 137),
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    if (index == 0) {}
                  },
                  tabs: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: const SizedBox(
                        height: 60,
                        width: 70,
                        child: MesAno(mes: "NOV", ano: "2023"),
                      ),
                    ),
                    DiaTab(day: 26),
                    DiaTab(day: 27),
                    DiaTab(day: 28),
                    DiaTab(day: 29),
                    DiaTab(day: 30),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const Center(
                  child: CardSobre(),
                ),
                Center(
                  child: CardEventos(
                    date: '2023-11-26',
                    database: widget.database,
                  ),
                ),
                Center(
                    child: CardEventos(
                  date: '2023-11-27',
                  database: widget.database,
                )),
                Center(
                  child: CardEventos(
                    date: '2023-11-28',
                    database: widget.database,
                  ),
                ),
                Center(
                  child: CardEventos(
                    date: '2023-11-29',
                    database: widget.database,
                  ),
                ),
                Center(
                  child: CardEventos(
                    date: '2023-11-30',
                    database: widget.database,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
