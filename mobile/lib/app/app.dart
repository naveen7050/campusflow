import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import '../features/notes/presentation/viewmodels/note_viewmodel.dart';
import '../features/materials/presentation/viewmodels/material_viewmodel.dart';
import '../features/assignments/presentation/viewmodels/assignment_viewmodel.dart';
import '../features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'constants/app_constants.dart';
import 'routes.dart';
import 'theme/app_theme.dart';
import 'theme/theme_viewmodel.dart';

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
        ChangeNotifierProvider(
          create: (_) => NoteViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MaterialViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AssignmentViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => QuestionViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeViewModel(),
        ),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVm, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeVm.themeMode,
            routes: AppRoutes.routes,
            // Always start at Splash — it handles the routing logic
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}

