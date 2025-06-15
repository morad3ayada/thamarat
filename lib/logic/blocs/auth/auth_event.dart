import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  final bool isUserInitiated;

  const LogoutRequested({this.isUserInitiated = true});

  @override
  List<Object?> get props => [isUserInitiated];
}

class CheckAuthStatus extends AuthEvent {}
