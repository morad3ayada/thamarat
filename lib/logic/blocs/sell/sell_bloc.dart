import 'package:flutter_bloc/flutter_bloc.dart';
import 'sell_event.dart';
import 'sell_state.dart';
import 'package:thamarat/data/repositories/sell_repository.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  final SellRepository sellRepository;

  SellBloc({required this.sellRepository}) : super(SellInitial()) {
    on<LoadSellProcesses>(_onLoadProcesses);
    on<LoadSellDetails>(_onLoadDetails);
    on<ConfirmSell>(_onConfirmSell);
  }

  Future<void> _onLoadProcesses(LoadSellProcesses event, Emitter<SellState> emit) async {
    emit(SellLoading());
    try {
      final items = await sellRepository.fetchSellProcesses();
      emit(SellLoaded(items));
    } catch (e) {
      emit(SellError(e.toString()));
    }
  }

  Future<void> _onLoadDetails(LoadSellDetails event, Emitter<SellState> emit) async {
    emit(SellLoading());
    try {
      final details = await sellRepository.getSellDetails(event.id);
      emit(SellDetailsLoaded(details));
    } catch (e) {
      emit(SellError(e.toString()));
    }
  }

  Future<void> _onConfirmSell(ConfirmSell event, Emitter<SellState> emit) async {
    emit(SellLoading());
    try {
      await sellRepository.confirmSell(event.id);
      emit(SellConfirmed());
      add(LoadSellProcesses());
    } catch (e) {
      emit(SellError(e.toString()));
    }
  }
}
