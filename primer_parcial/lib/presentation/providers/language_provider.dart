import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primer_parcial/core/language/language.dart';

final languageProvider = StateProvider<Language>((ref) => Language.spanish);
