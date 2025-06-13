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

class ConfirmSell extends SellEvent {
  final int id;
  const ConfirmSell(this.id);

  @override
  List<Object?> get props => [id];
}

class AddSellMaterial extends SellEvent {
  final String customerName;
  final String customerPhone;
  final String materialName;
  final String fridgeName;
  final String sellType;
  final double quantity;
  final double price;
  final double? commission;
  final double? traderCommission;
  final double? officeCommission;
  final double? brokerage;
  final double? pieceRate;
  final double? weight;

  const AddSellMaterial({
    required this.customerName,
    required this.customerPhone,
    required this.materialName,
    required this.fridgeName,
    required this.sellType,
    required this.quantity,
    required this.price,
    this.commission,
    this.traderCommission,
    this.officeCommission,
    this.brokerage,
    this.pieceRate,
    this.weight,
  });

  @override
  List<Object?> get props => [
    customerName,
    customerPhone,
    materialName,
    fridgeName,
    sellType,
    quantity,
    price,
    commission,
    traderCommission,
    officeCommission,
    brokerage,
    pieceRate,
    weight,
  ];
}
