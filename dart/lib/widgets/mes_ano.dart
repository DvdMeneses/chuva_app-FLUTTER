import 'package:flutter/material.dart';

class MesAno extends StatelessWidget {
  final String mes;
  final String ano;

  const MesAno({
    Key? key,
    required this.mes,
    required this.ano,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Define a cor de fundo como branca
      child: SizedBox(
        width: 70,
        height: 60,
        child: Tab(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$mes',
                style: TextStyle(
                  color: Colors.black, // Define a cor do texto como preto
                ),
              ),
              Text(
                '$ano',
                style: TextStyle(
                  color: Colors.black, // Define a cor do texto como preto
                  fontWeight:
                      FontWeight.bold, // Define o peso da fonte como negrito
                  fontSize: 18, // Define o tamanho da fonte como 18
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
