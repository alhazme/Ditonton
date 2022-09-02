import 'package:core/data/models/tv_model.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Arrange
  final tvModel = TVModel(
      posterPath: '/path.jpg',
      popularity: 1000.0,
      id: 1,
      backdropPath: '/path.jpg',
      voteAverage: 1.0,
      overview: 'overview',
      firstAirDate: '2020-05-05',
      originCountry: ['US'],
      genreIds: [1],
      originalLanguage: 'en',
      voteCount: 1,
      name: 'name',
      originalName: 'originalName'
  );
  final tvModelJson = {
    'poster_path': '/path.jpg',
    'popularity': 1000.0,
    'id': 1,
    'backdrop_path': '/path.jpg',
    'vote_average': 1.0,
    'overview': 'overview',
    'first_air_date': '2020-05-05',
    'origin_country': ['US'],
    'genre_ids': [1],
    'original_language': 'en',
    'vote_count': 1,
    'name': 'name',
    'original_name': 'originalName'
  };
  final tv = TV(
      posterPath: '/path.jpg',
      popularity: 1000.0,
      id: 1,
      backdropPath: '/path.jpg',
      voteAverage: 1.0,
      overview: 'overview',
      firstAirDate: '2020-05-05',
      originCountry: ['US'],
      genreIds: [1],
      originalLanguage: 'en',
      voteCount: 1,
      name: 'name',
      originalName: 'originalName'
  );

  test('should be a equal to TV model', () async {
    // Act
    final result = TVModel.fromJson(tvModelJson);
    // Result
    expect(result, tvModel);
  });
  test('should be a equal to TV model', () async {
    // Act
    final result = tvModel.toJson();
    // Result
    expect(result, tvModelJson);
  });
  test('should be a equal to TV Entity', () async {
    // Act
    final result = tvModel.toEntity();
    // Result
    expect(result, tv);
  });
}