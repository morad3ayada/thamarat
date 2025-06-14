import 'package:equatable/equatable.dart';
import 'package:thamarat/data/models/sell_model.dart';

abstract class SellState extends Equatable {
  const SellState();
  @override
  List<Object?> get props => [];
}

class SellInitial extends SellState {}

class SellLoading extends SellState {}

class SellLoaded extends SellState {
  final List<SellModel> items;
  const SellLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class SellDetailsLoaded extends SellState {
  final SellModel sell;
  const SellDetailsLoaded(this.sell);

  @override
  List<Object?> get props => [sell];
}

class SaleProcessCreated extends SellState {
  final int saleProcessId;
  final String customerName;
  final String customerPhone;

  const SaleProcessCreated({
    required this.saleProcessId,
    required this.customerName,
    required this.customerPhone,
  });

  @override
  List<Object?> get props => [saleProcessId, customerName, customerPhone];
}

class SellConfirmed extends SellState {}

class SellError extends SellState {
  final String message;
  const SellError(this.message);

  @override
  List<Object?> get props => [message];
}
