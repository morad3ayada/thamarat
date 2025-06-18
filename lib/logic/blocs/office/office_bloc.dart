import 'package:flutter_bloc/flutter_bloc.dart';
import 'office_event.dart';
import 'office_state.dart';
import 'package:thamarat/data/repositories/office_repository.dart';
import 'package:thamarat/core/utils/logo_cache.dart';

class OfficeBloc extends Bloc<OfficeEvent, OfficeState> {
  final OfficeRepository officeRepository;
  bool _hasLoadedOffice = false;
  bool _isLoading = false;

  OfficeBloc({required this.officeRepository}) : super(OfficeInitial()) {
    on<LoadOfficeInfo>(_onLoadOfficeInfo);
  }

  Future<void> _onLoadOfficeInfo(LoadOfficeInfo event, Emitter<OfficeState> emit) async {
    // Prevent multiple simultaneous loads
    if (_isLoading) {
      return;
    }

    // If already loaded, don't reload
    if (_hasLoadedOffice && state is OfficeLoaded) {
      return;
    }

    _isLoading = true;
    emit(OfficeLoading());
    
    try {
      // Try to get cached logo first
      final cachedLogo = await LogoCache.getCachedLogo();
      
      if (cachedLogo != null) {
        // If we have a cached logo, emit it immediately
        emit(OfficeLoaded({'logo': cachedLogo}));
      }

      // Then fetch fresh data from the server
      final officeInfo = await officeRepository.getOfficeInfo();
      
      // Cache the new logo if it exists
      if (officeInfo['logo'] != null && officeInfo['logo'].toString().isNotEmpty) {
        await LogoCache.cacheLogo(officeInfo['logo']);
      }
      
      // Emit the fresh data
      emit(OfficeLoaded(officeInfo));
      _hasLoadedOffice = true;
    } catch (e) {
      emit(OfficeError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  // Method to reset the loaded state (useful for logout)
  void resetLoadedState() {
    _hasLoadedOffice = false;
    _isLoading = false;
  }
} 