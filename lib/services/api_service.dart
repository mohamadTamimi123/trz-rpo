// lib/api_service.dart

import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> getRole(String message) async {
    const openRouterApikey =
        "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";

    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    String systemPrompt = """
تو یک مشاور متخصص در زمینه ۱۲ قدم و طرحواره‌ها هستی.  
فقط و فقط در قالب یک JSON با کلید "emotion" پاسخ بده، به شکل زیر:
{ "emotion": "ترس" }

- رنجش و دلچرکین شدن  
- ترس  
- احساس گناه، شرم و خجالت  
- غم و اندوه  
- افسردگی و ناامیدی  

هیچ توضیح یا متنی اضافه نده.
""";
    final data = {
      "model": "deepseek/deepseek-r1-0528:free",
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": message}
      ]
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer $openRouterApikey',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);

        final data = jsonDecode(decoded);
        final content = data['choices'][0]['message']['content'];

        // حالا محتوای JSON مدل رو پارس می‌کنیم:
        final emotionJson = jsonDecode(content);
        final emotion = emotionJson['emotion'];

        return 'ارسال موفق: ${emotion}';
      } else {
        return 'خطا در ارسال: ${response.statusCode}';
      }
    } catch (e) {
      return 'خطا در ارتباط با سرور';
    }
  }
}
