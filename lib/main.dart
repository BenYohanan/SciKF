import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_feeds/providers/SciKFProvider.dart';
import 'package:news_feeds/route/route_constants.dart';
import 'package:news_feeds/route/router.dart' as router;
import 'package:news_feeds/services/DatabaseHelper.dart';
import 'package:news_feeds/services/StorageService.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  final storageService = StorageService();
  await storageService.init();
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  runApp(MyApp(dbHelper: dbHelper, storageService: storageService));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;
  final StorageService storageService;

  const MyApp({super.key, required this.dbHelper, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SizeConfig().init(context);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => SciKFProvider(storageService)
                ..loadUserData()
                ..loadMainPageData(),
            ),
          ],
          child: MaterialApp(
            title: 'News Feeds',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(context),
            themeMode: ThemeMode.light,
            onGenerateRoute: router.generateRoute,
            initialRoute: onbordingScreenRoute,
          ),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // For testing only
  }
}