import 'package:get/get.dart';
import 'package:localizeit/app/core/values/it_it.dart';

import 'en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'it_IT': itIT
      };
}
