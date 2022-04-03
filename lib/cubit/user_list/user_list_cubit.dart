import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_chat/models/user_data.dart';
import 'package:mobile_chat/repository/user_list_repository.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  final UserListRepository userListRepository;
  StreamSubscription? _userListSubscription;
  UserListCubit({
    required this.userListRepository,
  }) : super(const UserListState());

  void fetchUsers() async {
    _userListSubscription?.cancel();
    _userListSubscription = userListRepository.streamUserList().listen((users) {
      emit(state.copyWith(users: users));
    });
  }
}
