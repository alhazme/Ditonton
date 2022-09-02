import 'package:ditonton/data/models/tv_last_episode_to_air_model.dart';
import 'package:ditonton/domain/entities/tv_last_episode_to_air.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  // Arrange
  final tvLastEpisodeToAirModel = TVLastEpisodeToAirModel(
      airDate: DateTime.parse('2020-05-05'),
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: 'xxx',
      seasonNumber: 1,
      stillPath: '/path.jpg',
      voteAverage: 1.0,
      voteCount: 1
  );
  final tvLastEpisodeToAirModelJson = {
    'air_date': '2020-05-05',
    'episode_number': 1,
    'id': 1,
    'name': 'name',
    'overview': 'overview',
    'production_code': 'xxx',
    'season_number': 1,
    'still_path': '/path.jpg',
    'vote_average': 1.0,
    'vote_count': 1
  };
  final tvLastEpisodeToAir = TVLastEpisodeToAir(
      airDate: DateTime.parse('2020-05-05'),
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: 'xxx',
      seasonNumber: 1,
      stillPath: '/path.jpg',
      voteAverage: 1.0,
      voteCount: 1
  );

  test('should be a equal to TVLastEpisodeToAir model', () async {
    // Act
    final result = TVLastEpisodeToAirModel.fromJson(tvLastEpisodeToAirModelJson);
    // Result
    expect(result, tvLastEpisodeToAirModel);
  });
  test('should be a equal to TVLastEpisodeToAir model', () async {
    // Act
    final result = tvLastEpisodeToAirModel.toJson();
    // Result
    expect(result, tvLastEpisodeToAirModelJson);
  });
  test('should be a equal to TVLastEpisodeToAir Entity', () async {
    // Act
    final result = tvLastEpisodeToAirModel.toEntity();
    // Result
    expect(result, tvLastEpisodeToAir);
  });
}