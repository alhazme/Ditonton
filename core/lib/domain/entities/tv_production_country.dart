import 'package:equatable/equatable.dart';

class TVProductionCountry extends Equatable {
  const TVProductionCountry({
    required this.iso31661,
    required this.name,
  });

  final String iso31661;
  final String name;

  @override
  List<Object?> get props => [
    iso31661,
    name,
  ];
}