import 'package:flutter/material.dart';

class DiaTab extends StatelessWidget {
  final int day;

  const DiaTab({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Tab(
        child: Text(
          '$day',
          style: TextStyle(
            color: Colors.white, // Define a cor do texto como branca
          ),
        ),
      ),
    );
  }
}
