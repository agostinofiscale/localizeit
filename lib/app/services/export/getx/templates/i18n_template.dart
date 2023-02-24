String i18nTemplate = '''
import 'package:get/get.dart';
{% for language in languages %}
import '{{language}}.dart';
{% endfor %}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    {% for language in languages %}
    '{{language}}': {{language}},
    {% endfor %}
  };
}
''';