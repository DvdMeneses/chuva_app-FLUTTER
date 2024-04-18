import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

Column cardEvento(
  String categoryColor,
  String type,
  String startTime,
  String endTime,
  String title,
  String personName,
  String? personName2,
) {
  Color color =
      categoryColor.isNotEmpty ? fromCssColor(categoryColor) : Colors.black;
  print("cor recebida no cardEvento :" + '$color');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 120,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 330, // Defina a largura desejada
              padding: const EdgeInsets.only(
                  left: 10, bottom: 5), // Adicione um espaçamento inferior
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type + ' de ' + startTime + ' até ' + endTime,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                      height: 5), // Adicionando algum espaço entre os textos
                  Text(
                    title,
                    maxLines: 2, // Limita o título a duas linhas
                    overflow: TextOverflow
                        .ellipsis, // Exibe reticências se o título for cortado
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (personName != personName2) // Verifica se são diferentes
                    Text(
                      '$personName, $personName2',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    )
                  else
                    Text(
                      '$personName',
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
  );
}
