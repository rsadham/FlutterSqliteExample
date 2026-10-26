import '../../core/database/app_database.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final AppDatabase database;

  UserRepositoryImpl(this.database);

  @override
  Future<void> addUser(UserModel user) async {
    await database.insertUser(user.toMap());
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final data = await database.getUsers();

    return data.map((json) => UserModel.fromMap(json)).toList();
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await database.updateUser(user.id!, user.toMap());
  }

  @override
  Future<void> deleteUser(int id) async {
    await database.deleteUser(id);
  }
}
