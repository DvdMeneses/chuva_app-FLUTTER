import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class CardSobre extends StatelessWidget {
  const CardSobre({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      'https://avatars.githubusercontent.com/u/115294207?s=400&u=d4a2cccef94686d943395d492bfbea1bb4008e0d&v=4',
                      fit: BoxFit.cover,
                      width: 180,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3.0,
                      vertical: 8.0,
                    ),
                    child: const Text(
                      'David Meneses',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Outros atributos, se necessário
                ],
              ),
            ),
            SizedBox(height: 16), // Espaçamento abaixo do card
            GestureDetector(
              onTap: () {
                launch("https://github.com/DvdMeneses");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://1000logos.net/wp-content/uploads/2021/05/GitHub-logo.png',
                    fit: BoxFit.cover,
                    width: 70,
                    height: 50,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Oi, você entrou no easter egg. Agradeço por ter visto meu app. Aqui é uma página dedicada a agradecimentos. Agradeço primeiramente a Deus por ter me abençoado e capacitado até hoje. Agradeço ao meu professor Tanirio Chacon, que me ensinou a desenvolver em mobile e até hoje serve de inspiração e está sempre lá para tirar dúvidas. Agradeço à Giovanna, minha parceira, que me acompanhou durante o processo. Obrigado a cada um e obrigado por estarem sempre me apoiando a cada passo.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
