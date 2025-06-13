import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thamarat/data/repositories/materials_repository.dart';
import 'materials_event.dart';
import 'materials_state.dart';

class MaterialsBloc extends Bloc<MaterialsEvent, MaterialsState> {
  final MaterialsRepository materialsRepository;

  MaterialsBloc({required this.materialsRepository}) : super(MaterialsInitial()) {
    on<LoadMaterials>(_onLoadMaterials);
    on<SearchMaterials>(_onSearchMaterials);
    on<AddMaterial>(_onAddMaterial);
    on<DeleteMaterial>(_onDeleteMaterial);
  }

  Future<void> _onLoadMaterials(LoadMaterials event, Emitter<MaterialsState> emit) async {
    emit(MaterialsLoading());
    try {
      final items = await materialsRepository.fetchMaterials();
      emit(MaterialsLoaded(items));
    } catch (e) {
      emit(MaterialsError(e.toString()));
    }
  }

  Future<void> _onSearchMaterials(SearchMaterials event, Emitter<MaterialsState> emit) async {
    emit(MaterialsLoading());
    try {
      final items = await materialsRepository.fetchMaterials();
      final filteredItems = items.where((material) =>
          material.name.toLowerCase().contains(event.query.toLowerCase())).toList();
      emit(MaterialsLoaded(filteredItems));
    } catch (e) {
      emit(MaterialsError(e.toString()));
    }
  }

  Future<void> _onAddMaterial(AddMaterial event, Emitter<MaterialsState> emit) async {
    try {
      await materialsRepository.addMaterial(event.material);
      add(LoadMaterials()); // Refresh list
    } catch (e) {
      emit(MaterialsError(e.toString()));
    }
  }

  Future<void> _onDeleteMaterial(DeleteMaterial event, Emitter<MaterialsState> emit) async {
    try {
      await materialsRepository.deleteMaterial(event.id);
      add(LoadMaterials()); // Refresh list
    } catch (e) {
      emit(MaterialsError(e.toString()));
    }
  }
}
