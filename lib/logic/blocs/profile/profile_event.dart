import 'package:equatable/equatable.dart';
import 'package:thamarat/data/models/user_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UpdateProfileRequest request;

  const UpdateProfile(this.request);

  @override
  List<Object?> get props => [request];
}
