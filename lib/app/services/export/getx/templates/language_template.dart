String languageTemplate = '''
final Map<String, String> {{ isoCode }} = {
  {% for key, value in translations %}
  "{{key}}": "{{value}}",
  {% endfor %}
};
''';