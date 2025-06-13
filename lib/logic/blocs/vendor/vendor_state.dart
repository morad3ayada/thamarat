import 'package:equatable/equatable.dart';
import '../../../data/models/vendor_model.dart';

abstract class VendorState extends Equatable {
  const VendorState();
  @override
  List<Object?> get props => [];
}

class VendorInitial extends VendorState {}

class VendorLoading extends VendorState {}

class VendorsLoaded extends VendorState {
  final List<VendorModel> vendors;
  const VendorsLoaded(this.vendors);

  @override
  List<Object?> get props => [vendors];
}

class VendorDetailsLoaded extends VendorState {
  final VendorModel vendor;
  const VendorDetailsLoaded(this.vendor);

  @override
  List<Object?> get props => [vendor];
}

class VendorError extends VendorState {
  final String message;
  const VendorError(this.message);

  @override
  List<Object?> get props => [message];
}

class VendorConfirmed extends VendorState {}
