part of 'user_list_cubit.dart';

class UserListState extends Equatable {
  const UserListState({this.users = const []});

  final List<UserData> users;

  UserListState copyWith({
    List<UserData>? users,
  }) {
    return UserListState(users: users ?? this.users);
  }

  @override
  List<Object> get props => [users];
}
