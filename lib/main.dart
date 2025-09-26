import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'constants/app_constants.dart';
import 'helpers/notification_helper.dart';
import './networks/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationHelper.initialize();
  runApp(const NatureSyncApp());
}

class NatureSyncApp extends StatelessWidget {
  const NatureSyncApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // adjust to your design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appName,
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: const Color(AppConstants.primaryColor),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(AppConstants.primaryColor),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(AppConstants.primaryColor),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppConstants.primaryColor),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(AppConstants.primaryColor),
              foregroundColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.initialRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
