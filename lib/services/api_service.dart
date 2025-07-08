// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const _apiKey =
      "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";
  static final _url =
      Uri.parse("https://openrouter.ai/api/v1/chat/completions");

  static Future<String> getRole(String message) async {
    const String systemPrompt =
        "تو یک مشاور متخصص در زمینه ۱۲ قدم و طرحواره‌ها هستی.\n"
        "فقط و فقط در قالب یک JSON با کلید \"emotion\" پاسخ بده، به شکل زیر:\n"
        "{ \"emotion\": \"ترس\" }\n\n"
        "- رنجش و دلچرکین شدن\n"
        "- ترس\n"
        "- احساس گناه، شرم و خجالت\n"
        "- غم و اندوه\n"
        "- افسردگی و ناامیدی\n\n"
        "هیچ توضیح یا متنی اضافه نده.";

    return await _postToModel(message, systemPrompt, 'emotion');
  }

  static Future<String> getSelfWill(String message, String role) async {
    const String selfWill = "خشم\n"
        "ناصادقی\n"
        "حسادت\n"
        "پرخوری / افراط در خوردن\n"
        "خودبزرگ‌بینی\n"
        "طمع\n"
        "آسیب رساندن\n"
        "نفرت\n"
        "بی‌صبری\n"
        "بی‌توجهی به دیگران\n"
        "تعصب / عدم تحمل\n"
        "تن‌پروری\n"
        "شهوت‌گرایی\n"
        "غرور\n"
        "تعلل / اهمال‌کاری\n"
        "سرزنش خود\n"
        "حق به جانب بودن\n"
        "ترحم به حال خود\n"
        "خودمحوری\n"
        "بدبینی\n"
        "بی‌وفایی";

    const String schemas = "رهاشدگی/بی‌ثباتی\n"
        "بی‌اعتمادی/بدرفتاری\n"
        "محرومیت هیجانی\n"
        "نقص/شرم\n"
        "انزوای اجتماعی/بیگانگی\n"
        "وابستگی/بی‌کفایتی\n"
        "آسیب‌پذیری نسبت به ضرر یا بیماری\n"
        "گرفتاری/درهم‌تنیدگی\n"
        "شکست\n"
        "استحقاق/بزرگ‌منشی\n"
        "خودمهارگری ناکافی\n"
        "تابعیت\n"
        "ایثارگری\n"
        "تاییدطلبی/جلب توجه\n"
        "منفی‌گرایی/بدبینی\n"
        "بازداری هیجانی\n"
        "استانداردهای سختگیرانه/عیب‌جویی افراطی\n"
        "تنبیه‌گرایی";
    const String systemPrompt =
        "تو یک مشاور متخصص در زمینه ۱۲ قدم و طرحواره‌های ناسازگار هستی.\n\n"
        "ماجرایی برایت ارسال می‌شود، به همراه احساسی که کاربر تجربه کرده است.\n"
        "وظیفه‌ی تو این است که **فقط و فقط از لیست کامل نواقص موجود در متغیر defects پاسخ بده** و هرکدام را در یکی از سه دسته‌ی زیر قرار دهی:\n\n"
        "- \"مرتبط‌ترین‌ها\": نواقصی که نقش اصلی یا پررنگی در شکل‌گیری این ماجرا داشته‌اند.\n"
        "- \"کم‌ارتباط‌ها\": نواقصی که به صورت خفیف یا غیرمستقیم ممکن است تأثیرگذار باشند.\n"
        "- \"بی‌ارتباط‌ها\": نواقصی که به هیچ عنوان با ماجرا مرتبط نیستند.\n\n"
        "🔴 مهم: تو باید **تمام نواقص موجود در لیست defects را به‌صورت کامل بررسی کرده و حتماً در یکی از سه دسته‌ی بالا قرار دهی. هیچ نقصی نباید از قلم بیفتد. همچنین از هیچ مورد خارج از این لیست استفاده نکن.**\n\n"
        "برای هر نقصی که در دسته‌ی «مرتبط‌ترین‌ها» یا «کم‌ارتباط‌ها» قرار می‌گیرد، یک تحلیل بسیار کوتاه بنویس (۱ تا ۲ جمله) که توضیح دهد این نقص چگونه در ماجرا نقش داشته است.\n"
        "دسته‌ی «بی‌ارتباط‌ها» فقط شامل نام نقص‌هاست و نیاز به تحلیل ندارد.\n\n"
        "📌 فقط و فقط یک شیء JSON خالص بده. هیچ توضیح اضافه‌ای، هیچ عبارت متنی، و هیچ قالب‌بندی مانند ```json یا '''json یا code block ننویس.\n\n"
        "فرمت دقیق پاسخ باید به شکل زیر باشد:\n"
        "{\n"
        "  \"مرتبط‌ترین‌ها\": [[\"اسم نقص ۱\", \"تحلیل کوتاه\"]],\n"
        "  \"کم‌ارتباط‌ها\": [[\"اسم نقص ۲\", \"تحلیل کوتاه\"]],\n"
        "  \"بی‌ارتباط‌ها\": [\"اسم نقص ۳\", \"اسم نقص ۴\"]\n"
        "}\n\n"
        "## لیست کامل نواقص (defects):\n"
        "$selfWill";

    final String userPromp = "ماجرا\n"
        "$message \n"
        "نقش\n"
        "$role";

    return await _postToModel(userPromp, systemPrompt, 'response');
  }

  // تابع مشترک برای فرستادن داده به مدل
  static Future<String> _postToModel(
      String message, String systemPrompt, String fieldName) async {
    final data = {
      "model": "deepseek/deepseek-r1-0528:free",
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": message}
      ]
    };

    try {
      final response = await http.post(
        _url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer $_apiKey',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final json = jsonDecode(decoded);
        final content = json['choices'][0]['message']['content'];
        // final resultJson = jsonDecode(content);
        return '$content';
      } else {
        return 'خطا در ارسال: ${response.statusCode}';
      }
    } catch (e) {
      return 'خطا در ارتباط با سرور';
    }
  }
}
