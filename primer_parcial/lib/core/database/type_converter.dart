import 'package:floor/floor.dart';
import 'package:primer_parcial/domain/models/user.dart';

class GenderConverter extends TypeConverter<Gender, int> {
  @override
  Gender decode(int databaseValue) {
    return Gender.values[databaseValue];
  }

  @override
  int encode(Gender value) {
    return value.index;
  }
}
