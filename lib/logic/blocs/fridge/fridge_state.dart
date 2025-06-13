import 'package:equatable/equatable.dart';
import 'package:thamarat/data/models/fridge_model.dart';

abstract class FridgeState extends Equatable {
  const FridgeState();
  @override
  List<Object?> get props => [];
}

class FridgeInitial extends FridgeState {}

class FridgeLoading extends FridgeState {}

class FridgeLoaded extends FridgeState {
  final List<FridgeModel> items;

  const FridgeLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class FridgeDetailsLoaded extends FridgeState {
  final FridgeModel fridge;

  const FridgeDetailsLoaded(this.fridge);

  @override
  List<Object?> get props => [fridge];
}

class FridgeError extends FridgeState {
  final String message;

  const FridgeError(this.message);

  @override
  List<Object?> get props => [message];
}
