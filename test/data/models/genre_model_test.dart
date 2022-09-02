import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {

  // Arrange
  final genreModel = GenreModel(id: 1, name: 'Action');
  final genreJson = {
    "id": 1,
    "name": 'Action',
  };
  final genre = Genre(id: 1, name: 'Action');

  test('should be a equal to Genre model', () async {
    // Act
    final result = GenreModel.fromJson(genreJson);
    // Result
    expect(result, genreModel);
  });
  test('should be a equal to Genre model', () async {
    // Act
    final result = genreModel.toJson();
    // Result
    expect(result, genreJson);
  });
  test('should be a equal to Genre Entity', () async {
    // Act
    final result = genreModel.toEntity();
    // Result
    expect(result, genre);
  });
}