import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryService {
  static const String _url = 'https://restcountries.com/v3.1/region/europe';

  Future<List<dynamic>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data;
        } else {
          throw Exception('No results found.');
        }
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }
}