import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Favorite Screen")));
  }
}
