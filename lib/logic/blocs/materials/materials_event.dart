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

class AddMaterialToSaleProcess extends MaterialsEvent {
  final int saleProcessId;
  final int materialId;
  final String materialType;
  final double? quantity;
  final double? weight;
  final double price;
  final int order;
  final double? commissionPercentage;
  final double? traderCommissionPercentage;
  final double? officeCommissionPercentage;
  final double? brokerCommissionPercentage;
  final double? pieceFees;
  final double? traderPiecePercentage;
  final double? workerPiecePercentage;
  final double? officePiecePercentage;

  const AddMaterialToSaleProcess({
    required this.saleProcessId,
    required this.materialId,
    required this.materialType,
    this.quantity,
    this.weight,
    required this.price,
    this.order = 1,
    this.commissionPercentage,
    this.traderCommissionPercentage,
    this.officeCommissionPercentage,
    this.brokerCommissionPercentage,
    this.pieceFees,
    this.traderPiecePercentage,
    this.workerPiecePercentage,
    this.officePiecePercentage,
  });

  @override
  List<Object?> get props => [
    saleProcessId,
    materialId,
    materialType,
    quantity,
    weight,
    price,
    order,
    commissionPercentage,
    traderCommissionPercentage,
    officeCommissionPercentage,
    brokerCommissionPercentage,
    pieceFees,
    traderPiecePercentage,
    workerPiecePercentage,
    officePiecePercentage,
  ];
}

class DeleteMaterial extends MaterialsEvent {
  final int id;
  const DeleteMaterial(this.id);

  @override
  List<Object?> get props => [id];
}
