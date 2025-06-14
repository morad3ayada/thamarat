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
    try {
      emit(FridgeLoading());
      final items = await fridgeRepository.fetchFridgeItems();
      emit(FridgeLoaded(items));
    } catch (e) {
      print('Error loading fridge items: $e');
      emit(FridgeError('حدث خطأ في تحميل قائمة البرادات: ${e.toString()}'));
    }
  }

  Future<void> _onLoadDetails(LoadFridgeDetails event, Emitter<FridgeState> emit) async {
    try {
      emit(FridgeLoading());
      final fridge = await fridgeRepository.getFridgeDetails(event.id);
      emit(FridgeDetailsLoaded(fridge));
    } catch (e) {
      print('Error loading fridge details: $e');
      // Don't emit error state to prevent crashes, just emit initial state
      emit(FridgeInitial());
    }
  }
}
