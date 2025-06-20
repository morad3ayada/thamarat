import 'package:equatable/equatable.dart';

abstract class SellEvent extends Equatable {
  const SellEvent();
  @override
  List<Object?> get props => [];
}

class LoadSellProcesses extends SellEvent {}

class LoadSellDetails extends SellEvent {
  final int id;
  const LoadSellDetails(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateNewSaleProcess extends SellEvent {
  final int customerId;
  final String customerName;
  final String customerPhone;

  const CreateNewSaleProcess({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
  });

  @override
  List<Object?> get props => [customerId, customerName, customerPhone];
}

class ConfirmSell extends SellEvent {
  final int id;
  const ConfirmSell(this.id);

  @override
  List<Object?> get props => [id];
}

class AddMaterialToSaleProcess extends SellEvent {
  final int saleProcessId;
  final int materialId;
  final String materialType;
  final double? price;
  final double? quantity;
  final double? weight;
  final bool? isRate;
  final double? commissionPercentage;
  final double? traderCommissionPercentage;
  final double? officeCommissionPercentage;
  final double? brokerCommissionPercentage;
  final double? pieceFees;
  final double? traderPiecePercentage;
  final double? workerPiecePercentage;
  final double? officePiecePercentage;
  final double? brokerPiecePercentage;

  const AddMaterialToSaleProcess({
    required this.saleProcessId,
    required this.materialId,
    required this.materialType,
    this.price,
    this.quantity,
    this.weight,
    this.isRate,
    this.commissionPercentage,
    this.traderCommissionPercentage,
    this.officeCommissionPercentage,
    this.brokerCommissionPercentage,
    this.pieceFees,
    this.traderPiecePercentage,
    this.workerPiecePercentage,
    this.officePiecePercentage,
    this.brokerPiecePercentage,
  });

  @override
  List<Object?> get props => [
    saleProcessId,
    materialId,
    materialType,
    price,
    quantity,
    weight,
    isRate,
    commissionPercentage,
    traderCommissionPercentage,
    officeCommissionPercentage,
    brokerCommissionPercentage,
    pieceFees,
    traderPiecePercentage,
    workerPiecePercentage,
    officePiecePercentage,
    brokerPiecePercentage,
  ];
}

class DeleteSellMaterial extends SellEvent {
  final int materialId;
  final String materialType;
  final String uniqueId;

  const DeleteSellMaterial({
    required this.materialId,
    required this.materialType,
    required this.uniqueId,
  });

  @override
  List<Object?> get props => [materialId, materialType, uniqueId];
}
