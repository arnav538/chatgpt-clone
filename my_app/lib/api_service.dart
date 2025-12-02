import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService {
  static const String _apiKey = 'AIzaSyDU4MygbTNQJs_R6HBBBKpCxTH_jOlYJMY';

  // Using the standard 1.5 Flash model
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  final Logger _logger = Logger();

  Future<String> sendMessage(String message) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": message},
            ],
          },
        ],
      };

      _logger.i("Sending request to: $url");
      _logger.i("Request body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      _logger.i("Response status: ${response.statusCode}");
      _logger.i("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            return candidate['content']['parts'][0]['text'];
          }
        }
        return "No response generated.";
      } else if (response.statusCode == 401) {
        _logger.e(
          'API Error: 401 Unauthorized. Check your API key permissions.',
        );
        return "Error 401: Unauthorized. Please check your API key.";
      } else if (response.statusCode == 404) {
        _logger.e(
          'API Error: 404 Not Found. This usually means the API key is not enabled for this model.',
        );
        return "Error 404: Model not found.\n\nFIX: Create a NEW API Key at aistudio.google.com and ensure 'Generative Language API' is enabled.";
      } else if (response.statusCode == 500) {
        _logger.e('API Error: 500 Internal Server Error.');
        return "Error 500: Internal Server Error. Try again later.";
      } else {
        _logger.e('API Error: ${response.statusCode}\n${response.body}');
        return "Error ${response.statusCode}: ${response.reasonPhrase}";
      }
    } catch (e) {
      _logger.e('Exception: $e');
      return "Failed to connect: $e";
    }
  }
}
