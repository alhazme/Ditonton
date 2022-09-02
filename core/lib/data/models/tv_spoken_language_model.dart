import 'package:core/domain/entities/tv_spoken_language.dart';
import 'package:equatable/equatable.dart';

class TVSpokenLanguageModel extends Equatable {
  TVSpokenLanguageModel({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  final String englishName;
  final String iso6391;
  final String name;

  factory TVSpokenLanguageModel.fromJson(Map<String, dynamic> json) => TVSpokenLanguageModel(
    englishName: json["english_name"],
    iso6391: json["iso_639_1"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "english_name": englishName,
    "iso_639_1": iso6391,
    "name": name,
  };

  TVSpokenLanguage toEntity() {
    return TVSpokenLanguage(
        englishName: this.englishName,
        iso6391: this.iso6391,
        name: this.name
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    englishName,
    iso6391,
    name,
  ];
}
