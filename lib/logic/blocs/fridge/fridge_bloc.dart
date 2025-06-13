import 'package:flutter_bloc/flutter_bloc.dart';
import 'fridge_event.dart';
import 'fridge_state.dart';
import 'package:thamarat/data/repositories/fridge_repository.dart';

class FridgeBloc extends Bloc<FridgeEvent, FridgeState> {
  final FridgeRepository fridgeRepository;

  FridgeBloc({required this.fridgeRepository}) : super(FridgeInitial()) {
    on<LoadFridgeItems>(_onLoadItems);
    on<LoadFridgeDetails>(_onLoadDetails);
  }

  Future<void> _onLoadItems(LoadFridgeItems event, Emitter<FridgeState> emit) async {
    emit(FridgeLoading());
    try {
      final items = await fridgeRepository.fetchFridgeItems();
      emit(FridgeLoaded(items));
    } catch (e) {
      emit(FridgeError(e.toString()));
    }
  }

  Future<void> _onLoadDetails(LoadFridgeDetails event, Emitter<FridgeState> emit) async {
    emit(FridgeLoading());
    try {
      final fridge = await fridgeRepository.getFridgeDetails(event.id);
      emit(FridgeDetailsLoaded(fridge));
    } catch (e) {
      emit(FridgeError(e.toString()));
    }
  }
}
