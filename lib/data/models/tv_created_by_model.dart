import 'package:ditonton/domain/entities/tv_created_by.dart';
import 'package:equatable/equatable.dart';

class TVCreatedByModel extends Equatable {
  TVCreatedByModel({
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
        id: this.id,
        creditId: this.creditId,
        name: this.name,
        gender: this.gender,
        profilePath: this.profilePath
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    creditId,
    name,
    gender,
    profilePath,
  ];
}