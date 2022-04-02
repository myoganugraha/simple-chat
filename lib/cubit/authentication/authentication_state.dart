part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationOnLoading extends AuthenticationState {}

class AuthenticationOnSuccess extends AuthenticationState {}

class AuthenticationOnError extends AuthenticationState {}