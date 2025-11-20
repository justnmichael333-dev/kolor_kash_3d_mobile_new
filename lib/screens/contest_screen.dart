import 'package:flutter/material.dart';

class ContestScreen extends StatelessWidget {
  const ContestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contests')),
      body: const Center(child: Text('Battle for Kashes here!')),
    );
  }
}
