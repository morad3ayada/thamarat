import 'package:equatable/equatable.dart';

abstract class OfficeState extends Equatable {
  const OfficeState();

  @override
  List<Object?> get props => [];
}

class OfficeInitial extends OfficeState {}

class OfficeLoading extends OfficeState {}

class OfficeLoaded extends OfficeState {
  final Map<String, dynamic> officeInfo;

  const OfficeLoaded(this.officeInfo);

  @override
  List<Object?> get props => [officeInfo];
}

class OfficeError extends OfficeState {
  final String message;

  const OfficeError(this.message);

  @override
  List<Object?> get props => [message];
} 