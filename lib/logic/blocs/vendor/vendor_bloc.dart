import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/vendor_repository.dart';
import 'vendor_event.dart';
import 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final VendorRepository _vendorRepository;

  VendorBloc(this._vendorRepository) : super(VendorInitial()) {
    on<LoadVendors>(_onLoadVendors);
    on<SearchVendors>(_onSearchVendors);
    on<AddVendor>(_onAddVendor);
    on<UpdateVendor>(_onUpdateVendor);
    on<DeleteVendor>(_onDeleteVendor);
    on<LoadVendorDetails>(_onLoadVendorDetails);
  }

  Future<void> _onLoadVendors(LoadVendors event, Emitter<VendorState> emit) async {
    try {
      emit(VendorLoading());
      final vendors = await _vendorRepository.getVendors();
      emit(VendorsLoaded(vendors));
    } catch (e) {
      emit(VendorError(e.toString()));
    }
  }

  Future<void> _onSearchVendors(SearchVendors event, Emitter<VendorState> emit) async {
    try {
      emit(VendorLoading());
      final vendors = await _vendorRepository.searchVendors(event.query);
      emit(VendorsLoaded(vendors));
    } catch (e) {
      emit(VendorError(e.toString()));
    }
  }

  Future<void> _onAddVendor(AddVendor event, Emitter<VendorState> emit) async {
    try {
      emit(VendorLoading());
      await _vendorRepository.addVendor(
        name: event.name,
        phone: event.phone,
        address: event.address,
      );
      final vendors = await _vendorRepository.getVendors();
      emit(VendorsLoaded(vendors));
      emit(VendorConfirmed());
    } catch (e) {
      emit(VendorError(e.toString()));
    }
  }

  Future<void> _onUpdateVendor(UpdateVendor event, Emitter<VendorState> emit) async {
    try {
      emit(VendorLoading());
      await _vendorRepository.updateVendor(
        id: event.id,
        name: event.name,
        phone: event.phone,
        address: event.address,
      );
      final vendors = await _vendorRepository.getVendors();
      emit(VendorsLoaded(vendors));
      emit(VendorConfirmed());
    } catch (e) {
      emit(VendorError(e.toString()));
    }
  }

  Future<void> _onDeleteVendor(DeleteVendor event, Emitter<VendorState> emit) async {
    try {
      emit(VendorLoading());
      await _vendorRepository.deleteVendor(event.id);
      final vendors = await _vendorRepository.getVendors();
      emit(VendorsLoaded(vendors));
      emit(VendorConfirmed());
    } catch (e) {
      emit(VendorError(e.toString()));
    }
  }

  Future<void> _onLoadVendorDetails(LoadVendorDetails event, Emitter<VendorState> emit) async {
    try {
      emit(VendorLoading());
      final vendor = await _vendorRepository.getVendorDetails(event.id);
      emit(VendorDetailsLoaded(vendor));
    } catch (e) {
      emit(VendorError(e.toString()));
    }
  }
}
