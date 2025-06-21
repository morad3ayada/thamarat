import 'package:equatable/equatable.dart';
import 'package:thamarat/data/models/materials_model.dart';

abstract class MaterialsEvent extends Equatable {
  const MaterialsEvent();
  @override
  List<Object?> get props => [];
}

class LoadMaterials extends MaterialsEvent {}

class SearchMaterials extends MaterialsEvent {
  final String query;
  const SearchMaterials(this.query);

  @override
  List<Object?> get props => [query];
}

class AddMaterial extends MaterialsEvent {
  final MaterialsModel material;
  const AddMaterial(this.material);

  @override
  List<Object?> get props => [material];
}

class DeleteMaterial extends MaterialsEvent {
  final int id;
  const DeleteMaterial(this.id);

  @override
  List<Object?> get props => [id];
}
