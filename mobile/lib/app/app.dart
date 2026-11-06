import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import '../features/auth/presentation/views/login_view.dart';
import '../features/auth/presentation/views/splash_view.dart';
import '../features/home/presentation/views/home_view.dart';
import 'constants/app_constants.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel()..checkAuthStatus(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubjectViewModel(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routes: AppRoutes.routes,
        // Always start at Splash — it handles the routing logic
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}

