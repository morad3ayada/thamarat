import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:thamarat/data/repositories/profile_repository.dart';
import 'package:thamarat/core/utils/profile_cache.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  bool _hasLoadedProfile = false;
  bool _isLoading = false;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    // Prevent multiple simultaneous loads
    if (_isLoading) {
      return;
    }

    // If already loaded, don't reload
    if (_hasLoadedProfile && state is ProfileLoaded) {
      return;
    }

    _isLoading = true;
    emit(ProfileLoading());
    
    try {
      // Try to get cached profile first
      final cachedProfile = await ProfileCache.getCachedProfile();
      
      if (cachedProfile != null) {
        emit(ProfileLoaded(cachedProfile));
        _hasLoadedProfile = true;
        _isLoading = false;
        return;
      }

      // If no cache, fetch from server
      final user = await profileRepository.fetchProfile();
      await ProfileCache.cacheProfile(user);
      emit(ProfileLoaded(user));
      _hasLoadedProfile = true;
    } catch (e) {
      emit(ProfileError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final updatedUser = await profileRepository.updateProfile(event.request);
      await ProfileCache.cacheProfile(updatedUser);
      emit(ProfileLoaded(updatedUser));
      _hasLoadedProfile = true;
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Method to reset the loaded state (useful for logout)
  void resetLoadedState() {
    _hasLoadedProfile = false;
    _isLoading = false;
  }
}
