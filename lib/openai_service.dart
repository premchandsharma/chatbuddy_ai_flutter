import 'dart:convert';

import 'package:chatbuddy_ai_flutter/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo-16k",
            "messages": [
              {
                "role": "user",
                "content":
                    "Does this message want to generate an AI picture, image, art or anything similar? $prompt. Simply answer with a yes or no.",
              }
            ],
          },
        ),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }
      return 'An internal error occurred!';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo-16k",
            "messages": messages,
          },
        ),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });

        return content;
      }
      return 'An internal error occurred!';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIKey'
        },
        body: jsonEncode(
          {
            "model": "dall-e-3",
            "prompt": prompt,
          },
        ),
      );

      if (res.statusCode == 200) {
        String imgUrl = jsonDecode(res.body)['data'][0]['url'];
        imgUrl = imgUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imgUrl,
        });

        return imgUrl;
      }
      return 'An internal error occurred!';
    } catch (e) {
      return e.toString();
    }
  }
}
