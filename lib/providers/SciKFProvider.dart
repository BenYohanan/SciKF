import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news_feeds/services/StorageService.dart';

import '../model/innovation_model.dart';
import '../model/user.dart';
import '../services/storage_keys.dart';

class SciKFProvider extends ChangeNotifier {
  ApplicationUser? user;
  List<InnovationModel> recentInnovations = [];
  List<InnovationModel> flashInnovations = [];
  List<InnovationModel> approvedInnovations = [];
  List<InnovationModel> myInnovations = [];
  bool isLoading = false;
  final StorageService _storageService;

  SciKFProvider(this._storageService);

  Future<void> updateAfterLogin({
    required ApplicationUser user,
    required List<InnovationModel> recentInnovations,
    required List<InnovationModel> flashInnovations,
    required List<InnovationModel> approvedInnovations,
    required List<InnovationModel> myInnovations,
  }) async {
    isLoading = true;
    notifyListeners();

    this.user = user;
    this.recentInnovations = recentInnovations;
    this.flashInnovations = flashInnovations;
    this.approvedInnovations = approvedInnovations;
    this.myInnovations = myInnovations;

    await _storageService.saveToLocalStorage(loginUserKey, jsonEncode(user.toJson()));
    await _storageService.saveToLocalStorage(loginUserIdKey, user.id!);
    await _storageService.saveToLocalStorage(isAdminKey, user.isAdmin.toString());
    await _storageService.saveToLocalStorage(
        recentInnovationsKey, jsonEncode(recentInnovations.map((e) => e.toJson()).toList()));
    await _storageService.saveToLocalStorage(
        flashInnovationsKey, jsonEncode(flashInnovations.map((e) => e.toJson()).toList()));
    await _storageService.saveToLocalStorage(
        approvedInnovationsKey, jsonEncode(approvedInnovations.map((e) => e.toJson()).toList()));
    await _storageService.saveToLocalStorage(
        myInnovationsKey, jsonEncode(myInnovations.map((e) => e.toJson()).toList()));

    isLoading = false;
    notifyListeners();
  }
  Future<void> reload({
    required List<InnovationModel> recentInnovations,
    required List<InnovationModel> flashInnovations,
    required List<InnovationModel> approvedInnovations,
    required List<InnovationModel> myInnovations,
  }) async {
    isLoading = true;
    notifyListeners();
    this.recentInnovations = recentInnovations;
    this.flashInnovations = flashInnovations;
    this.approvedInnovations = approvedInnovations;
    this.myInnovations = myInnovations;

    await _storageService.saveToLocalStorage(
        recentInnovationsKey, jsonEncode(recentInnovations.map((e) => e.toJson()).toList()));
    await _storageService.saveToLocalStorage(
        flashInnovationsKey, jsonEncode(flashInnovations.map((e) => e.toJson()).toList()));
    await _storageService.saveToLocalStorage(
        approvedInnovationsKey, jsonEncode(approvedInnovations.map((e) => e.toJson()).toList()));
    await _storageService.saveToLocalStorage(
        myInnovationsKey, jsonEncode(myInnovations.map((e) => e.toJson()).toList()));

    isLoading = false;
    notifyListeners();
  }
  Future<void> loadUserData() async {
    isLoading = true;
    notifyListeners();
    final userJson = await _storageService.getFromLocalStorage(loginUserKey);
    if (userJson != null) {
      user = ApplicationUser.fromJson(jsonDecode(userJson));
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMainPageData() async {
    isLoading = true;
    notifyListeners();
    final recentJson = await _storageService.getFromLocalStorage(recentInnovationsKey);
    if (recentJson != null) {
      recentInnovations = (jsonDecode(recentJson) as List)
          .map((item) => InnovationModel.fromJson(item))
          .toList();
    }
    final flashJson = await _storageService.getFromLocalStorage(flashInnovationsKey);
    if (flashJson != null) {
      flashInnovations = (jsonDecode(flashJson) as List)
          .map((item) => InnovationModel.fromJson(item))
          .toList();
    }
    isLoading = false;
    notifyListeners();
  }
  // Future<void> createAndUpdateInnovation(InnovationDTO innovation, PlatformFile? file, PlatformFile? image) async {
  //   final newInnovation = InnovationModel(
  //     image: image?.name ?? '', // Use server-provided URL if available
  //     author: innovation.authorId ?? '',
  //     title: innovation.title ?? '',
  //     category: innovation.category?.displayName ?? '',
  //     status: 'Pending', // Default status
  //     date: DateTime.now().toString(), // Current date
  //   );
  //   recentInnovations.add(newInnovation);
  //   await _storageService.saveToLocalStorage(
  //     recentInnovationsKey,
  //     jsonEncode(recentInnovations.map((e) => e.toJson()).toList()),
  //   );
  //   notifyListeners();
  // }
  void clearState() {
    user = null;
    recentInnovations = [];
    flashInnovations = [];
    approvedInnovations = [];
    myInnovations = [];
    isLoading = false;
    notifyListeners();
  }
}