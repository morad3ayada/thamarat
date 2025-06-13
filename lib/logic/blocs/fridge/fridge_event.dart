import 'package:equatable/equatable.dart';

abstract class FridgeEvent extends Equatable {
  const FridgeEvent();

  @override
  List<Object?> get props => [];
}

class LoadFridgeItems extends FridgeEvent {}

class LoadFridgeDetails extends FridgeEvent {
  final int id;
  const LoadFridgeDetails(this.id);

  @override
  List<Object?> get props => [id];
}
