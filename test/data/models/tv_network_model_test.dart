import 'package:ditonton/data/models/tv_network_model.dart';
import 'package:ditonton/domain/entities/tv_network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Arrange
  final tvNetworkModel = TVNetworkModel(
      name: 'name',
      id: 1,
      logoPath: '/path.jpg',
      originCountry: 'en'
  );
  final tvNetworkModelJson = {
    'name': 'name',
    "id": 1,
    'logo_path': '/path.jpg',
    'origin_country': 'en'
  };
  final tvNetwork = TVNetwork(
      name: 'name',
      id: 1,
      logoPath: '/path.jpg',
      originCountry: 'en'
  );

  test('should be a equal to TVNetwork model', () async {
    // Act
    final result = TVNetworkModel.fromJson(tvNetworkModelJson);
    // Result
    expect(result, tvNetworkModel);
  });
  test('should be a equal to TVNetwork model', () async {
    // Act
    final result = tvNetworkModel.toJson();
    // Result
    expect(result, tvNetworkModelJson);
  });
  test('should be a equal to TVNetwork Entity', () async {
    // Act
    final result = tvNetworkModel.toEntity();
    // Result
    expect(result, tvNetwork);
  });
}