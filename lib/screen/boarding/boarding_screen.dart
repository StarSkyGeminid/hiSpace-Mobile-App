import 'package:flutter/material.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: const [
            Text('Boarding Screen'),
          ],
        ),
      ),
    );
  }
}
