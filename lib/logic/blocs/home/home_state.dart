import 'package:equatable/equatable.dart';
import 'package:thamarat/data/models/user_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserModel user;

  const HomeLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
} 