import 'package:flutter_bloc/flutter_bloc.dart';
import 'office_event.dart';
import 'office_state.dart';
import 'package:thamarat/data/repositories/office_repository.dart';

class OfficeBloc extends Bloc<OfficeEvent, OfficeState> {
  final OfficeRepository officeRepository;

  OfficeBloc({required this.officeRepository}) : super(OfficeInitial()) {
    on<LoadOfficeInfo>(_onLoadOfficeInfo);
  }

  Future<void> _onLoadOfficeInfo(LoadOfficeInfo event, Emitter<OfficeState> emit) async {
    emit(OfficeLoading());
    try {
      final officeInfo = await officeRepository.getOfficeInfo();
      emit(OfficeLoaded(officeInfo));
    } catch (e) {
      emit(OfficeError(e.toString()));
    }
  }
} 