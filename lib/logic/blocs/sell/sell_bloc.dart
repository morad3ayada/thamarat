import 'package:flutter_bloc/flutter_bloc.dart';
import 'sell_event.dart';
import 'sell_state.dart';
import 'package:thamarat/data/repositories/sell_repository.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  final SellRepository sellRepository;

  SellBloc({required this.sellRepository}) : super(SellInitial()) {
    on<LoadSellProcesses>(_onLoadProcesses);
    on<LoadSellDetails>(_onLoadDetails);
    on<CreateNewSaleProcess>(_onCreateNewSaleProcess);
    on<ConfirmSell>(_onConfirmSell);
    on<AddSellMaterial>(_onAddSellMaterial);
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

  Future<void> _onCreateNewSaleProcess(CreateNewSaleProcess event, Emitter<SellState> emit) async {
    emit(SellLoading());
    try {
      final result = await sellRepository.createNewSaleProcess(
        customerId: event.customerId,
        customerName: event.customerName,
        customerPhone: event.customerPhone,
      );
      
      emit(SaleProcessCreated(
        saleProcessId: result['id'],
        customerName: event.customerName,
        customerPhone: event.customerPhone,
      ));
      
      // Reload the processes to show the new one
      add(LoadSellProcesses());
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

  Future<void> _onAddSellMaterial(AddSellMaterial event, Emitter<SellState> emit) async {
    emit(SellLoading());
    try {
      await sellRepository.addSellMaterial(
        customerName: event.customerName,
        customerPhone: event.customerPhone,
        materialName: event.materialName,
        fridgeName: event.fridgeName,
        sellType: event.sellType,
        quantity: event.quantity,
        price: event.price,
        commission: event.commission,
        traderCommission: event.traderCommission,
        officeCommission: event.officeCommission,
        brokerage: event.brokerage,
        pieceRate: event.pieceRate,
        weight: event.weight,
      );
      emit(SellConfirmed());
      add(LoadSellProcesses());
    } catch (e) {
      emit(SellError(e.toString()));
    }
  }
}
