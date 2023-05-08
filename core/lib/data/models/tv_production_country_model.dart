import 'package:core/domain/entities/tv_production_country.dart';
import 'package:equatable/equatable.dart';

class TVProductionCountryModel extends Equatable {
  const TVProductionCountryModel({
    required this.iso31661,
    required this.name,
  });

  final String iso31661;
  final String name;

  factory TVProductionCountryModel.fromJson(Map<String, dynamic> json) => TVProductionCountryModel(
    iso31661: json["iso_3166_1"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "iso_3166_1": iso31661,
    "name": name,
  };

  TVProductionCountry toEntity() {
    return TVProductionCountry(
        iso31661: iso31661,
        name: name
    );
  }

  @override
  List<Object?> get props => [
    iso31661,
    name,
  ];
}