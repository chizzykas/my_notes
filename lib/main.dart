import 'package:flutter/material.dart';

import 'package:my_notes/presentation/pages/splash_screen.dart';
import 'package:my_notes/router/app_router.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utils/home_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.firebase().initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyNotesState(),
      child: const MyNotesApp(),
    ),
  );
}

class MyNotesApp extends StatefulWidget {
  const MyNotesApp({super.key});

  @override
  State<MyNotesApp> createState() => _MyNotesAppState();
}

class _MyNotesAppState extends State<MyNotesApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: BaseNavigator.key,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(),
        ),
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: SplashScreen.routeName,
      debugShowCheckedModeBanner: false,
    );
  }
}
