import 'package:core/data/models/tv_spoken_language_model.dart';
import 'package:core/domain/entities/tv_spoken_language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Arrange
  final tvSpokenLanguageModel = TVSpokenLanguageModel(
      englishName: 'english_name',
      iso6391: 'iso6391',
      name: 'name',
  );
  final tvSpokenLanguageJson = {
    "english_name": 'english_name',
    "iso_639_1": 'iso6391',
    "name": 'name'
  };
  final tvSpokenLanguage = TVSpokenLanguage(
      englishName: 'english_name',
      iso6391: 'iso6391',
      name: 'name'
  );

  test('should be a equal to TVSpokenLanguage model', () async {
    // Act
    final result = TVSpokenLanguageModel.fromJson(tvSpokenLanguageJson);
    // Result
    expect(result, tvSpokenLanguageModel);
  });
  test('should be a equal to TVSpokenLanguage model', () async {
    // Act
    final result = tvSpokenLanguageModel.toJson();
    // Result
    expect(result, tvSpokenLanguageJson);
  });
  test('should be a equal to TVSpokenLanguage Entity', () async {
    // Act
    final result = tvSpokenLanguageModel.toEntity();
    // Result
    expect(result, tvSpokenLanguage);
  });
}