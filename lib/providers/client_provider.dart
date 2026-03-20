import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/user.dart';
import '../model/auth_models.dart';
import '../providers/service_providers.dart';
import '../services/BaseHelperService.dart';

final clientServiceProvider = Provider<BaseHelperService>((ref) {
  return ref.read(baseHelperServiceProvider);
});

final clientListProvider =
StateNotifierProvider<ClientListNotifier, List<ApplicationUser>>((ref) {
  final service = ref.read(clientServiceProvider);
  return ClientListNotifier(service, ref);
});

class ClientListNotifier extends StateNotifier<List<ApplicationUser>> {
  final BaseHelperService _service;
  final Ref _ref;

  bool isLoading = false;

  ClientListNotifier(this._service, this._ref) : super([]) {
    loadClients();
  }

  Future<void> loadClients() async {
    try {
      isLoading = true;

      final users = await _service.getAllUsers();
      state = users;

      isLoading = false;
    } catch (e) {
      isLoading = false;
      state = [];
    }
  }

  Future<void> refreshClients() async {
    await loadClients();
  }

  Future<ApplicationUser?> getClientById(String id) async {
    try {
      return await _service.getUserById(id);
    } catch (e) {
      return null;
    }
  }

  Future<String> createClient(RegisterModel model) async {
    final result = await _service.register(model);

    if (result == "Successfully registered") {
      await refreshClients();
    }

    return result;
  }

  Future<void> updateClient(String id, UpdateUserModel model) async {
    try {
      await _service.updateUser(id, model);
      await refreshClients();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteClient(String id) async {
    try {
      await _service.deleteUser(id);
      state = state.where((user) => user.id != id).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> makeUserAdmin(String id) async {
    try {
      await _service.deleteUser(id);
      state = state.where((user) => user.id != id).toList();
    } catch (e) {
      rethrow;
    }
  }

  ApplicationUser? findClient(String id) {
    try {
      return state.firstWhere((user) => user.id == id);
    } catch (_) {
      return null;
    }
  }
}