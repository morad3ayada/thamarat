import 'package:equatable/equatable.dart';
import 'package:thamarat/data/models/user_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel user;

  const UpdateProfile(this.user);

  @override
  List<Object?> get props => [user];
}
