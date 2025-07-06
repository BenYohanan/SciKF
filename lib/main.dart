import 'package:flutter/material.dart';
import 'package:news_feeds/routes.dart';
import 'package:news_feeds/services/DatabaseHelper.dart';
import 'package:news_feeds/size_config.dart';

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
          theme: ThemeData(
            primarySwatch: createMaterialColor(Color(0xFF2E7D32)),
            primaryColor: Color(0xFF2E7D32),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Roboto'),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: getRoutes(),
        );
      },
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}