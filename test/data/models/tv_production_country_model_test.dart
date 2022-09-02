import 'package:ditonton/data/models/tv_production_country_model.dart';
import 'package:ditonton/domain/entities/tv_production_country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Arrange
  final tvProductionCountryModel = TVProductionCountryModel(
      iso31661: 'iso31661',
      name: 'name'
  );
  final tvProductionCountryModelJson = {
    "iso_3166_1": 'iso31661',
    'name': 'name'
  };
  final tvProductionCountry = TVProductionCountry(
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