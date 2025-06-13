import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thamarat/data/repositories/profile_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProfileRepository profileRepository;

  HomeBloc({
    required this.profileRepository,
  }) : super(HomeInitial()) {
    on<LoadUserData>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(LoadUserData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final user = await profileRepository.fetchProfile();
      emit(HomeLoaded(user));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
} 