import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_model.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final userNameController = TextEditingController();
  final userLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<UserCubit>().loadUsers();
  }

  @override
  void dispose() {
    userNameController.dispose();
    userLocationController.dispose();

    super.dispose();
  }

  void clearFields() {
    userNameController.clear();
    userLocationController.clear();
  }

  void saveUser() {
    final userName = userNameController.text.trim();
    final userLocation = userLocationController.text.trim();

    if (userName.isEmpty || userLocation.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter all fields')));

      return;
    }

    context.read<UserCubit>().addUser(
      userName: userName,
      userLocation: userLocation,
    );

    clearFields();

    FocusScope.of(context).unfocus();
  }

  void editUser(UserModel user) {
    userNameController.text = user.userName;
    userLocationController.text = user.userLocation;

    final userCubit = context.read<UserCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: userCubit,
          child: AlertDialog(
            title: const Text('Edit User'),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: userLocationController,
                  decoration: const InputDecoration(
                    labelText: 'User Location',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),

            actions: [
              TextButton(
                onPressed: () {
                  clearFields();
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancel'),
              ),

              ElevatedButton(
                onPressed: () {
                  final name = userNameController.text.trim();
                  final location = userLocationController.text.trim();

                  if (name.isEmpty || location.isEmpty) {
                    return;
                  }

                  userCubit.updateUser(
                    id: user.id!,
                    userName: name,
                    userLocation: location,
                  );

                  clearFields();

                  Navigator.pop(dialogContext);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteUser(int id) {
    final userCubit = context.read<UserCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: userCubit,
          child: AlertDialog(
            title: const Text('Delete User'),

            content: const Text('Are you sure you want to delete this user?'),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancel'),
              ),

              ElevatedButton(
                onPressed: () {
                  userCubit.deleteUser(id);

                  Navigator.pop(dialogContext);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite CRUD')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: userNameController,

              decoration: const InputDecoration(
                labelText: 'User Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: userLocationController,

              decoration: const InputDecoration(
                labelText: 'User Location',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: saveUser,

                child: const Text('SAVE'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.users.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }

                  return ListView.builder(
                    itemCount: state.users.length,

                    itemBuilder: (context, index) {
                      final user = state.users[index];

                      return Card(
                        child: ListTile(
                          title: Text(user.userName),

                          subtitle: Text(user.userLocation),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),

                                onPressed: () {
                                  editUser(user);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete),

                                onPressed: () {
                                  deleteUser(user.id!);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
