part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationOnLoading extends AuthenticationState {}

class AuthenticationOnSuccess extends AuthenticationState {}

class AuthenticationOnError extends AuthenticationState {
  final String message;

  const AuthenticationOnError(this.message);
}

class UnauthenticationOnLoading extends AuthenticationState {}

class UnauthenticationOnSuccess extends AuthenticationState {}

class UnauthenticationOnError extends AuthenticationState {
  final String message;

  const UnauthenticationOnError(this.message);
}

