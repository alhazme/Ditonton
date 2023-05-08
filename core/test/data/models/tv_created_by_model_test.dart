import 'package:core/data/models/tv_created_by_model.dart';
import 'package:core/domain/entities/tv_created_by.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Arrange
  const tvCreatedByModel = TVCreatedByModel(
    id: 1,
    creditId: '1',
    name: 'name',
    gender: 1,
    profilePath: '/test.jpg'
  );
  final tvCreatedByJson = {
    "id": 1,
    "credit_id": '1',
    "name": 'name',
    "gender": 1,
    "profile_path": '/test.jpg'
  };
  const tvCreatedBy = TVCreatedBy(
    id: 1,
    creditId: '1',
    name: 'name',
    gender: 1,
    profilePath: '/test.jpg'
  );

  test('should be a equal to TVCreatedBy model', () async {
    // Act
    final result = TVCreatedByModel.fromJson(tvCreatedByJson);
    // Result
    expect(result, tvCreatedByModel);
  });
  test('should be a equal to TVCreatedBy model', () async {
    // Act
    final result = tvCreatedByModel.toJson();
    // Result
    expect(result, tvCreatedByJson);
  });
  test('should be a equal to TVCreatedBy Entity', () async {
    // Act
    final result = tvCreatedByModel.toEntity();
    // Result
    expect(result, tvCreatedBy);
  });
}