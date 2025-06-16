import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:thamarat/data/repositories/profile_repository.dart';
import 'package:thamarat/core/utils/profile_cache.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  bool _hasLoadedProfile = false;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    if (_hasLoadedProfile) {
      return;
    }

    emit(ProfileLoading());
    try {
      final cachedProfile = await ProfileCache.getCachedProfile();
      
      if (cachedProfile != null) {
        emit(ProfileLoaded(cachedProfile));
        _hasLoadedProfile = true;
        return;
      }

      final user = await profileRepository.fetchProfile();
      await ProfileCache.cacheProfile(user);
      emit(ProfileLoaded(user));
      _hasLoadedProfile = true;
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final updatedUser = await profileRepository.updateProfile(event.request);
      await ProfileCache.cacheProfile(updatedUser);
      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
