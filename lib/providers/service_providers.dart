import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/BaseHelperService.dart';
import '../services/DatabaseHelper.dart';
import '../services/StorageService.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError();
});

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  throw UnimplementedError();
});
final baseHelperServiceProvider = Provider<BaseHelperService>((ref) {
  return BaseHelperService();
});