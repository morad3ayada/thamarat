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
    on<AddMaterialToSaleProcess>(_onAddMaterialToSaleProcess);
    on<DeleteSellMaterial>(_onDeleteSellMaterial);
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

  Future<void> _onAddMaterialToSaleProcess(AddMaterialToSaleProcess event, Emitter<SellState> emit) async {
    emit(SellLoading());
    try {
      await sellRepository.addMaterialToSaleProcess(
        saleProcessId: event.saleProcessId,
        materialId: event.materialId,
        materialType: event.materialType,
        price: event.price,
        quantity: event.quantity,
        weight: event.weight,
        isRate: event.isRate,
        commissionPercentage: event.commissionPercentage,
        traderCommissionPercentage: event.traderCommissionPercentage,
        officeCommissionPercentage: event.officeCommissionPercentage,
        brokerCommissionPercentage: event.brokerCommissionPercentage,
        pieceFees: event.pieceFees,
        traderPiecePercentage: event.traderPiecePercentage,
        workerPiecePercentage: event.workerPiecePercentage,
        officePiecePercentage: event.officePiecePercentage,
        brokerPiecePercentage: event.brokerPiecePercentage,
        materialUniqueId: event.materialUniqueId,
      );
      emit(SellConfirmed());
      add(LoadSellProcesses());
    } catch (e) {
      emit(SellError(e.toString()));
    }
  }

  Future<void> _onDeleteSellMaterial(DeleteSellMaterial event, Emitter<SellState> emit) async {
    emit(SellLoading());
    try {
      await sellRepository.deleteSellMaterial(
        materialId: event.materialId,
        materialType: event.materialType,
      );
      emit(SellConfirmed());
      add(LoadSellProcesses());
    } catch (e) {
      emit(SellError(e.toString()));
    }
  }
}
