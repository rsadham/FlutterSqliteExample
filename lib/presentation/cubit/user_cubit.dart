import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit(this.repository) : super(UserState());

  // READ
  Future<void> loadUsers() async {
    try {
      emit(state.copyWith(isLoading: true));

      final users = await repository.getUsers();

      emit(state.copyWith(users: users, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // CREATE
  Future<void> addUser({
    required String userName,
    required String userLocation,
  }) async {
    try {
      final user = UserModel(userName: userName, userLocation: userLocation);

      await repository.addUser(user);

      await loadUsers();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // UPDATE
  Future<void> updateUser({
    required int id,
    required String userName,
    required String userLocation,
  }) async {
    try {
      final user = UserModel(
        id: id,
        userName: userName,
        userLocation: userLocation,
      );

      await repository.updateUser(user);

      await loadUsers();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // DELETE
  Future<void> deleteUser(int id) async {
    try {
      await repository.deleteUser(id);

      await loadUsers();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
