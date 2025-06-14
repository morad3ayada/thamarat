import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thamarat/data/repositories/materials_repository.dart';
import 'package:thamarat/data/models/materials_model.dart';
import 'materials_event.dart';
import 'materials_state.dart';

class MaterialsBloc extends Bloc<MaterialsEvent, MaterialsState> {
  final MaterialsRepository materialsRepository;
  List<MaterialsModel> _allMaterials = [];

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
      _allMaterials = items;
      // Sort materials by order
      _allMaterials.sort((a, b) => a.order.compareTo(b.order));
      emit(MaterialsLoaded(_allMaterials));
    } catch (e) {
      emit(MaterialsError(e.toString()));
    }
  }

  Future<void> _onSearchMaterials(SearchMaterials event, Emitter<MaterialsState> emit) async {
    if (event.query.isEmpty) {
      emit(MaterialsLoaded(_allMaterials));
    } else {
      final filteredItems = _allMaterials.where((material) =>
          material.name.toLowerCase().contains(event.query.toLowerCase()) ||
          material.source.toLowerCase().contains(event.query.toLowerCase()) ||
          material.displayType.toLowerCase().contains(event.query.toLowerCase()) ||
          material.materialType.toLowerCase().contains(event.query.toLowerCase())
      ).toList();
      emit(MaterialsLoaded(filteredItems));
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

  // Helper method to get materials by type
  List<MaterialsModel> getMaterialsByType(String type) {
    return _allMaterials.where((material) => material.materialType == type).toList();
  }

  // Helper method to get materials by truck
  List<MaterialsModel> getMaterialsByTruck(String truckName) {
    return _allMaterials.where((material) => material.truckName == truckName).toList();
  }

  // Helper method to get unique truck names
  List<String> getUniqueTruckNames() {
    return _allMaterials
        .map((material) => material.truckName)
        .where((name) => name != null && name.isNotEmpty)
        .map((name) => name!)
        .toSet()
        .toList();
  }
}
