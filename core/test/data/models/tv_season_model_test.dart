import 'package:core/data/models/tv_season_model.dart';
import 'package:core/domain/entities/tv_season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Arrange
  final tvSeasonModel = TVSeasonModel(
      airDate: DateTime.parse('2020-05-05'),
      episodeCount: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: '/path.jpg',
      seasonNumber: 1
  );
  final tvSeasonModelJson = {
    "air_date": '2020-05-05',
    "episode_count": 1,
    'id': 1,
    'name': 'name',
    'overview': 'overview',
    'poster_path': '/path.jpg',
    'season_number': 1
  };
  final tvSeason = TVSeason(
      airDate: DateTime.parse('2020-05-05'),
      episodeCount: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: '/path.jpg',
      seasonNumber: 1
  );

  test('should be a equal to TVSeason model', () async {
    // Act
    final result = TVSeasonModel.fromJson(tvSeasonModelJson);
    // Result
    expect(result, tvSeasonModel);
  });
  test('should be a equal to TVSeason model', () async {
    // Act
    final result = tvSeasonModel.toJson();
    // Result
    expect(result, tvSeasonModelJson);
  });
  test('should be a equal to TVSeason Entity', () async {
    // Act
    final result = tvSeasonModel.toEntity();
    // Result
    expect(result, tvSeason);
  });
}