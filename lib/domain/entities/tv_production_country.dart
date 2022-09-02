import 'package:equatable/equatable.dart';

class TVProductionCountry extends Equatable {
  TVProductionCountry({
    required this.iso31661,
    required this.name,
  });

  final String iso31661;
  final String name;

  @override
  // TODO: implement props
  List<Object?> get props => [
    iso31661,
    name,
  ];
}