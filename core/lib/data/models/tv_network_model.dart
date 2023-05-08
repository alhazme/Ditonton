import 'package:core/domain/entities/tv_network.dart';
import 'package:equatable/equatable.dart';

class TVNetworkModel extends Equatable {
  const TVNetworkModel({
    required this.name,
    required this.id,
    required this.logoPath,
    required this.originCountry,
  });

  final String name;
  final int id;
  final String logoPath;
  final String originCountry;

  factory TVNetworkModel.fromJson(Map<String, dynamic> json) => TVNetworkModel(
    name: json["name"],
    id: json["id"],
    logoPath: json["logo_path"] ?? "",
    originCountry: json["origin_country"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "logo_path": logoPath,
    "origin_country": originCountry,
  };

  TVNetwork toEntity() {
    return TVNetwork(
        name: name,
        id: id,
        logoPath: logoPath,
        originCountry: originCountry
    );
  }

  @override
  List<Object?> get props => [
    name,
    id,
    logoPath,
    originCountry,
  ];
}