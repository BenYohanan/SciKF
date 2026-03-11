import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feeds/providers/sci_kf_notifier.dart';
import 'package:news_feeds/providers/service_providers.dart';
import 'package:news_feeds/route/route_constants.dart';
import 'package:news_feeds/route/router.dart' as router;
import 'package:news_feeds/services/DatabaseHelper.dart';
import 'package:news_feeds/services/StorageService.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  final storageService = StorageService();
  await storageService.init();

  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
        databaseHelperProvider.overrideWithValue(dbHelper),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(sciKFProvider.notifier).loadUserData();
      ref.read(sciKFProvider.notifier).loadMainPageData();
    });
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Scivara',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(context),
        themeMode: ThemeMode.light,
        onGenerateRoute: router.generateRoute,
        initialRoute: onbordingScreenRoute,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}