import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_sqlite_bloc/presentation/cubit/user_cubit.dart';
import 'package:my_flutter_sqlite_bloc/presentation/screens/user_screen.dart';

import 'core/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'SQLite CRUD',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

        useMaterial3: true,
      ),

      home: BlocProvider(
        create: (_) => getIt<UserCubit>(),

        child: const UserScreen(),
      ),
    );
  }
}
