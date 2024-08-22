import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryDetailScreen extends StatelessWidget {
  final Country country;

  CountryDetailScreen({required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              country.flag,
              width: 150,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              'Name: ${country.name}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              'Capital: ${country.capital}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(
              'Population: ${country.population}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}