import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primer_parcial/core/language/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider = StateProvider<Language>((ref) => Language.spanish);

final languageRepositoryProvider =
    StateProvider<LanguageRepository>((ref) => LanguageRepository(ref: ref));

class LanguageRepository {
  LanguageRepository({required this.ref});
  final Ref ref;

  Future<void> setLanguage(Language language) async {
    final asyncPrefs = SharedPreferencesAsync();
    asyncPrefs.setString('language_code', language.code);
    ref.read(languageProvider.notifier).update((_) => language);
  }

  Future<Language> getLanguage() async {
    final asyncPrefs = SharedPreferencesAsync();
    final languageCode = await asyncPrefs.getString('language_code');
    if (languageCode != null) {
      for (var language in Language.values) {
        if (languageCode == language.code) return language;
      }
    }
    return Language.spanish;
  }
}
