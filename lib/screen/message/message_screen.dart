import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Chat', style: Theme.of(context).textTheme.titleMedium),
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
      ),
    );
  }
}
