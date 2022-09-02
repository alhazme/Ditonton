import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie_detail_response.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

void main() {

  // Arrange
  final movieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    budget: 1000,
    genres: [
      GenreModel(
        id: 1,
        name: 'name'
      )
    ],
    homepage: 'homepage',
    id: 1,
    imdbId: '1',
    originalLanguage: 'en',
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1000.0,
    posterPath: '/path.jpg',
    releaseDate: '2002-05-05',
    revenue: 1000,
    runtime: 1,
    status: 'status',
    tagline: 'tagline',
    title: 'title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final movieDetailResponseJson = {
    'adult': false,
    'backdrop_path': '/path.jpg',
    'budget': 1000,
    'genres': [
      {
        'id': 1,
        'name': 'name'
      }
    ],
    'homepage': 'homepage',
    'id': 1,
    'imdb_id': '1',
    'original_language': 'en',
    'original_title': 'originalTitle',
    'overview': 'overview',
    'popularity': 1000.0,
    'poster_path': '/path.jpg',
    'release_date': '2002-05-05',
    'revenue': 1000,
    'runtime': 1,
    'status': 'status',
    'tagline': 'tagline',
    'title': 'title',
    'video': false,
    'vote_average': 1.0,
    'vote_count': 1,
  };

  final movieDetail = MovieDetail(
      adult: false,
      backdropPath: '/path.jpg',
      genres: [
        Genre(
            id: 1,
            name: 'name'
        )
      ],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: '/path.jpg',
      releaseDate: '2002-05-05',
      runtime: 1000,
      title: 'title',
      voteAverage: 1.0,
      voteCount: 1
  );

  test('should be a equal to MovieDetail model', () async {
    // Act
    final result = MovieDetailResponse.fromJson(movieDetailResponseJson);
    // Result
    expect(result, movieDetailResponse);
  });
  test('should be a equal to MovieDetail model', () async {
    // Act
    final result = movieDetailResponse.toJson();
    // Result
    expect(result, movieDetailResponseJson);
  });
  test('should be a equal to MovieDetail Entity', () async {
    // Act
    final result = movieDetailResponse.toEntity();
    // Result
    expect(result, movieDetail);
  });
}