import 'package:core/domain/entities/tv_created_by.dart';
import 'package:equatable/equatable.dart';

class TVCreatedByModel extends Equatable {
  const TVCreatedByModel({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });

  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String profilePath;

  factory TVCreatedByModel.fromJson(Map<String, dynamic> json) => TVCreatedByModel(
    id: json["id"],
    creditId: json["credit_id"],
    name: json["name"],
    gender: json["gender"] ?? "",
    profilePath: json["profile_path"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "credit_id": creditId,
    "name": name,
    "gender": gender,
    "profile_path": profilePath,
  };

  TVCreatedBy toEntity() {
    return TVCreatedBy(
        id: id,
        creditId: creditId,
        name: name,
        gender: gender,
        profilePath: profilePath
    );
  }

  @override
  List<Object?> get props => [
    id,
    creditId,
    name,
    gender,
    profilePath,
  ];
}