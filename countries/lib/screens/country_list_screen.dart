import 'package:flutter/material.dart';
import '../models/country.dart';
import '../service/country_service.dart';
import 'country_detail_screen.dart';

class CountryListScreen extends StatefulWidget {
  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Country>> countries;
  List<Country> filteredCountries = [];
  TextEditingController searchController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
    countries.then((list) {
      setState(() {
        filteredCountries = list;
      });
    }).catchError((error) {
      setState(() {
        errorMessage = error.toString();
      });
    });
  }

  Future<List<Country>> fetchCountries() async {
    final data = await CountryService().fetchCountries();
    return data.map<Country>((json) => Country.fromJson(json)).toList();
  }

  void _filterCountries(String query) {
    if (query.isEmpty) {
      setState(() {
        countries.then((list) {
          filteredCountries = list;
        });
      });
    } else {
      setState(() {
        filteredCountries = filteredCountries
            .where((country) =>
                country.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _sortCountries(String criteria) {
    setState(() {
      filteredCountries.sort((a, b) {
        switch (criteria) {
          case 'Name':
            return a.name.compareTo(b.name);
          case 'Population':
            return b.population.compareTo(a.population);
          case 'Capital':
            return a.capital.compareTo(b.capital);
          default:
            return 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('European Countries'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortCountries,
            itemBuilder: (BuildContext context) {
              return {'Name', 'Population', 'Capital'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                _filterCountries(query);
              },
              decoration: InputDecoration(
                labelText: 'Search Countries',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : FutureBuilder<List<Country>>(
                    future: countries,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No countries found.'));
                      }

                      return ListView.builder(
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = filteredCountries[index];
                          return ListTile(
                            leading: Image.network(
                              country.flag,
                              width: 50,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                            title: Text(country.name),
                            subtitle: Text('Capital: ${country.capital}'),
                            trailing: Text('Population: ${country.population}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CountryDetailScreen(country: country),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}