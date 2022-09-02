import 'package:core/data/models/tv_model.dart';
import 'package:core/data/models/tv_response.dart';
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
      firstAirDate: '2002-05-05',
      originCountry: ['US'],
      genreIds: [1],
      originalLanguage: 'en',
      voteCount: 1,
      name: 'name',
      originalName: 'originalName'
  );
  final tvList = [tvModel];
  final tvResponse = TVResponse(tvList: tvList);
  final tvResponseJson = {
    'results': [
      {
        'poster_path': '/path.jpg',
        'popularity': 1000.0,
        'id': 1,
        'backdrop_path': '/path.jpg',
        'vote_average': 1.0,
        'overview': 'overview',
        'first_air_date': '2002-05-05',
        'origin_country': ['US'],
        'genre_ids': [1],
        'original_language': 'en',
        'vote_count': 1,
        'name': 'name',
        'original_name': 'originalName'
      }
    ]
  };

  test('should be a equal to TVResponse model', () async {
    // Act
    final result = TVResponse.fromJson(tvResponseJson);
    // Result
    expect(result, tvResponse);
  });
  test('should be a equal to Genre model', () async {
    // Act
    final result = tvResponse.toJson();
    // Result
    expect(result, tvResponseJson);
  });
}