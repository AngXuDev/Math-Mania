import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import '/src/ui/app/app.dart';
import '/src/ui/app/theme_provider.dart';
import '/src/ui/dashboard/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Uncomment the following lines when enabling Firebase Crashlytics
// import 'package:firebase_core/firebase_core.dart';
// import '/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Animate.restartOnHotReload = true;
  }

  final sharedPreferences = await SharedPreferences.getInstance();
  final themeProvider = ThemeProvider(sharedPreferences: sharedPreferences);

  setupServiceLocator(sharedPreferences, themeProvider);
  runApp(
    MultiProvider(
      providers: [
        // Provider<SharedPreferences>(create: (context) => sharedPreferences),
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (context) => GetIt.I.get<DashboardProvider>(),
        )
      ],
      child: MyApp(),
    ),
  );
}

setupServiceLocator(
  SharedPreferences sharedPreferences,
  ThemeProvider themeProvider,
) {
  GetIt.I.registerSingleton<ThemeProvider>(themeProvider);
  GetIt.I.registerSingleton<DashboardProvider>(
      DashboardProvider(preferences: sharedPreferences));
}
