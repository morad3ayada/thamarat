import 'package:equatable/equatable.dart';
import 'package:thamarat/data/models/materials_model.dart';

abstract class MaterialsState extends Equatable {
  const MaterialsState();
  @override
  List<Object?> get props => [];
}

class MaterialsInitial extends MaterialsState {}

class MaterialsLoading extends MaterialsState {}

class MaterialsLoaded extends MaterialsState {
  final List<MaterialsModel> materials;

  const MaterialsLoaded(this.materials);

  @override
  List<Object?> get props => [materials];
}

class MaterialsError extends MaterialsState {
  final String message;
  const MaterialsError(this.message);

  @override
  List<Object?> get props => [message];
}
