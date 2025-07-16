import 'package:flutter/material.dart';
import 'package:news_feeds/route/route_constants.dart';
import 'package:news_feeds/route/router.dart' as router;
import 'package:news_feeds/services/DatabaseHelper.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  runApp(MyApp(dbHelper: dbHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;
  const MyApp({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SizeConfig().init(context);
        return MaterialApp(
          title: 'News Feeds',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(context),
          themeMode: ThemeMode.light,
          onGenerateRoute: router.generateRoute,
          initialRoute: onbordingScreenRoute,
        );
      },
    );
  }
}