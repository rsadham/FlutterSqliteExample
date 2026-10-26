import '../../data/models/user_model.dart';

class UserState {
  final List<UserModel> users;
  final bool isLoading;
  final String? errorMessage;

  UserState({this.users = const [], this.isLoading = false, this.errorMessage});

  UserState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
