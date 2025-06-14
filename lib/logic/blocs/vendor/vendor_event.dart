import 'package:equatable/equatable.dart';

abstract class VendorEvent extends Equatable {
  const VendorEvent();
  @override
  List<Object?> get props => [];
}

class LoadVendors extends VendorEvent {}

class SearchVendors extends VendorEvent {
  final String query;

  const SearchVendors(this.query);

  @override
  List<Object?> get props => [query];
}

class AddVendor extends VendorEvent {
  final String name;
  final String phone;

  const AddVendor({
    required this.name,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, phone];
}

class UpdateVendor extends VendorEvent {
  final String id;
  final String name;
  final String phone;
  final String address;

  const UpdateVendor({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, phone, address];
}

class DeleteVendor extends VendorEvent {
  final String id;

  const DeleteVendor(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadVendorDetails extends VendorEvent {
  final int id;
  const LoadVendorDetails(this.id);

  @override
  List<Object?> get props => [id];
}
