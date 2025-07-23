import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_feeds/model/auth_models.dart';
import 'package:news_feeds/model/innovation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../services/BaseHelperService.dart';
import '../services/StorageService.dart';
import '../services/storage_keys.dart';

class SciKFProvider with ChangeNotifier {
  ApplicationUser? _user;
  List<InnovationModel>? _recentInnovations, _outstandingInnovations;
  bool _isAdmin = false;
  final StorageService _storageService = StorageService();

  ApplicationUser? get user => _user;
  List<InnovationModel> ? get recentInnovations  => _recentInnovations;
  List<InnovationModel> ? get outstandingInnovations  => _outstandingInnovations;
  bool get isAdmin => _isAdmin;

  Future<void> loadUserData() async {
    try {
      final userInString = await _storageService.getFromLocalStorage(loginUserKey);
      if (userInString!.isNotEmpty) {
        _user = ApplicationUser.fromJson(jsonDecode(userInString));
        _isAdmin = _user!.isAdmin;
        notifyListeners();
      } else {
        _user = null;
        _isAdmin = false;
        notifyListeners();
      }
    } catch (e) {
      _user = null;
      _isAdmin = false;
      notifyListeners();
    }
  }
  Future<void> loadMainPageData() async {
    try {
      final outstandingInnovationInString = await _storageService.getFromLocalStorage(flashInnovationsKey);
      final recentInString = await _storageService.getFromLocalStorage(recentInnovationsKey);
      if (outstandingInnovationInString!.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(outstandingInnovationInString);
        _outstandingInnovations = jsonList.map((item) => InnovationModel.fromJson(item)).toList();
        notifyListeners();
      } else {
        _outstandingInnovations = [];
        notifyListeners();
      }
      if (recentInString!.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(recentInString);
        _recentInnovations = jsonList.map((item) => InnovationModel.fromJson(item)).toList();
        notifyListeners();
      } else {
        _recentInnovations = [];
        notifyListeners();
      }
    } catch (e) {
      _recentInnovations = [];
      _outstandingInnovations = [];
      notifyListeners();
    }
  }
}