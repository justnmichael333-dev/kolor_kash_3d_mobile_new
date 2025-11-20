import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kolor Kash 3D - Home')),
      body: const Center(child: Text('Welcome to Kolor Kash 3D!')),
    );
  }
}
