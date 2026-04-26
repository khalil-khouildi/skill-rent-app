import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config.dart';

class AIService {
  final String _apiKey = AppConfig.groqApiKey;
  final String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<Map<String, String>?> generateRequestDetails(String prompt) async {
    if (prompt.isEmpty) return null;

    try {
      print('🤖 Appel de Groq IA pour: $prompt...');
      
      String url = _baseUrl;
      if (kIsWeb) {
        // Utilisation de corsproxy.io qui est plus fiable pour les requêtes POST
        url = 'https://corsproxy.io/?${Uri.encodeComponent(_baseUrl)}';
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content': 'Tu es un assistant expert pour l\'application Skill Rent. Génère un titre court et une description pour un service. Réponds UNIQUEMENT par un objet JSON valide.'
            },
            {
              'role': 'user',
              'content': 'Génère un JSON avec les champs "title" et "description" pour ce besoin: $prompt'
            }
          ],
          'temperature': 0.5,
          'response_format': {'type': 'json_object'},
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String content = data['choices'][0]['message']['content'];
        print('🤖 Réponse IA reçue: $content');
        
        final Map<String, dynamic> result = json.decode(content);
        return {
          'title': result['title'] ?? '',
          'description': result['description'] ?? '',
        };
      } else {
        print('❌ Erreur API Groq (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('❌ Erreur de génération IA: $e');
    }
    return null;
  }
}
