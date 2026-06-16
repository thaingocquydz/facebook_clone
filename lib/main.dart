import 'package:facebook_clone/constants/global_variables.dart';
import 'package:facebook_clone/features/auth/cubit/auth_cubit.dart';
import 'package:facebook_clone/features/auth/repository/auth_repository.dart';
import 'package:facebook_clone/features/auth/screens/login_screen.dart';
import 'package:facebook_clone/providers/user_provider.dart';
import 'package:facebook_clone/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepository()),
      child: MaterialApp(
        title: 'Facebook',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.backgroundColor,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: GlobalVariables.iconColor),
          ),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: const LoginScreen(),
      ),
    );
  }
}
