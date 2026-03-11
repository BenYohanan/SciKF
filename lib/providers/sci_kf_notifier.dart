import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feeds/providers/service_providers.dart';
import '../services/StorageService.dart';
import '../services/storage_keys.dart';
import '../model/user.dart';
import '../model/innovation_model.dart';
import 'sci_kf_state.dart';

class SciKFNotifier extends Notifier<SciKFState> {

  late final StorageService storageService;

  @override
  SciKFState build() {
    storageService = ref.read(storageServiceProvider);
    return const SciKFState();
  }

  Future<void> updateAfterLogin({
    required ApplicationUser user,
    required List<InnovationModel> recentInnovations,
    required List<InnovationModel> flashInnovations,
    required List<InnovationModel> approvedInnovations,
    required List<InnovationModel> myInnovations,
  }) async {

    state = state.copyWith(isLoading: true);

    state = state.copyWith(
      user: user,
      recentInnovations: recentInnovations,
      flashInnovations: flashInnovations,
      approvedInnovations: approvedInnovations,
      myInnovations: myInnovations,
    );

    await storageService.saveToLocalStorage(loginUserKey, jsonEncode(user.toJson()));
    await storageService.saveToLocalStorage(loginUserIdKey, user.id!);
    await storageService.saveToLocalStorage(isAdminKey, user.isAdmin.toString());

    await storageService.saveToLocalStorage(
        recentInnovationsKey,
        jsonEncode(recentInnovations.map((e) => e.toJson()).toList()));

    await storageService.saveToLocalStorage(
        flashInnovationsKey,
        jsonEncode(flashInnovations.map((e) => e.toJson()).toList()));

    await storageService.saveToLocalStorage(
        approvedInnovationsKey,
        jsonEncode(approvedInnovations.map((e) => e.toJson()).toList()));

    await storageService.saveToLocalStorage(
        myInnovationsKey,
        jsonEncode(myInnovations.map((e) => e.toJson()).toList()));

    state = state.copyWith(isLoading: false);
  }

  Future<void> loadUserData() async {

    state = state.copyWith(isLoading: true);

    final userJson = await storageService.getFromLocalStorage(loginUserKey);

    if (userJson != null) {
      final user = ApplicationUser.fromJson(jsonDecode(userJson));
      state = state.copyWith(user: user);
    }

    state = state.copyWith(isLoading: false);
  }

  Future<void> loadMainPageData() async {

    state = state.copyWith(isLoading: true);

    final recentJson = await storageService.getFromLocalStorage(recentInnovationsKey);

    if (recentJson != null) {
      final list = (jsonDecode(recentJson) as List)
          .map((item) => InnovationModel.fromJson(item))
          .toList();

      state = state.copyWith(recentInnovations: list);
    }

    final flashJson = await storageService.getFromLocalStorage(flashInnovationsKey);

    if (flashJson != null) {
      final list = (jsonDecode(flashJson) as List)
          .map((item) => InnovationModel.fromJson(item))
          .toList();

      state = state.copyWith(flashInnovations: list);
    }

    state = state.copyWith(isLoading: false);
  }

  Future<void> reload({
    required List<InnovationModel> recentInnovations,
    required List<InnovationModel> flashInnovations,
    required List<InnovationModel> approvedInnovations,
    required List<InnovationModel> myInnovations,
  }) async {

    state = state.copyWith(isLoading: true);

    state = state.copyWith(
      recentInnovations: recentInnovations,
      flashInnovations: flashInnovations,
      approvedInnovations: approvedInnovations,
      myInnovations: myInnovations,
    );

    await storageService.saveToLocalStorage(
      recentInnovationsKey,
      jsonEncode(recentInnovations.map((e) => e.toJson()).toList()),
    );

    await storageService.saveToLocalStorage(
      flashInnovationsKey,
      jsonEncode(flashInnovations.map((e) => e.toJson()).toList()),
    );

    await storageService.saveToLocalStorage(
      approvedInnovationsKey,
      jsonEncode(approvedInnovations.map((e) => e.toJson()).toList()),
    );

    await storageService.saveToLocalStorage(
      myInnovationsKey,
      jsonEncode(myInnovations.map((e) => e.toJson()).toList()),
    );

    state = state.copyWith(isLoading: false);
  }

  void clearState() {
    state = const SciKFState();
  }
}

final sciKFProvider = NotifierProvider<SciKFNotifier, SciKFState>(
  SciKFNotifier.new,
);