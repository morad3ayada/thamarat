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
