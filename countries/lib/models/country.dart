class Country {
  final String name;
  final String capital;
  final int population;
  final String flag;

  Country({required this.name, required this.capital, required this.population, required this.flag});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'],
      capital: (json['capital'] != null && json['capital'].isNotEmpty) ? json['capital'][0] : 'No Capital',
      population: json['population'],
      flag: json['flags']['png'],
    );
  }
}