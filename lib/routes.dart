import 'package:flutter/material.dart';
import 'package:news_feeds/screens/home/index.dart';
import 'package:news_feeds/screens/prompt_screen.dart';
import 'package:news_feeds/screens/response_list_screen.dart';
import 'package:news_feeds/services/DatabaseHelper.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/': (context) => HomeScreen(dbHelper: DatabaseHelper()),
    '/prompt': (context) => PromptScreen(dbHelper: DatabaseHelper()),
    '/response': (context) => ResponseListScreen(dbHelper: DatabaseHelper()),
  };
}