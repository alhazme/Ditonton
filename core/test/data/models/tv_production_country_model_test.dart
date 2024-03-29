import 'package:core/data/models/tv_production_country_model.dart';
import 'package:core/domain/entities/tv_production_country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Arrange
  const tvProductionCountryModel = TVProductionCountryModel(
      iso31661: 'iso31661',
      name: 'name'
  );
  final tvProductionCountryModelJson = {
    "iso_3166_1": 'iso31661',
    'name': 'name'
  };
  const tvProductionCountry = TVProductionCountry(
      iso31661: 'iso31661',
      name: 'name'
  );

  test('should be a equal to TVProductionCountry model', () async {
    // Act
    final result = TVProductionCountryModel.fromJson(tvProductionCountryModelJson);
    // Result
    expect(result, tvProductionCountryModel);
  });
  test('should be a equal to TVProductionCountry model', () async {
    // Act
    final result = tvProductionCountryModel.toJson();
    // Result
    expect(result, tvProductionCountryModelJson);
  });
  test('should be a equal to TVProductionCountry Entity', () async {
    // Act
    final result = tvProductionCountryModel.toEntity();
    // Result
    expect(result, tvProductionCountry);
  });
}