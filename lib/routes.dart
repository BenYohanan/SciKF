import 'package:flutter/material.dart';
import 'package:news_feeds/screens/home/index.dart';
import 'package:news_feeds/screens/prompt_screen.dart';
import 'package:news_feeds/screens/response_list_screen.dart';
import 'package:news_feeds/screens/splash_screen/splash_screen.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/splash': (context) => const SplashScreen(),
    '/': (context) => HomeScreen(),
    '/prompt': (context) => PromptScreen(),
    '/response': (context) => ResponseListScreen(),
  };
}