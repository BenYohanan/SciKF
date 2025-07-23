import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_feeds/services/storage_keys.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/auth_models.dart';
import '../model/innovationDTO.dart';
import '../model/innovation_model.dart';
import '../model/user.dart';
import '../providers/SciKFProvider.dart';
import 'StorageService.dart';

class BaseHelperService {
  final http.Client _client = http.Client();
  final StorageService _storageService = StorageService();

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<String> register(RegisterModel model) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/Account/register'),
      headers: _getHeaders(),
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      return "Successfully registered";
    } else {
      var message = jsonDecode(response.body);
      return "${message['msg']}";
    }
  }

  Future<String> login(LoginModel model, BuildContext context) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/Account/login'),
      headers: _getHeaders(),
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final apiResponse = jsonDecode(response.body);
      var user = ApplicationUser.fromJson(apiResponse['user']);
      var recentInnovations = (apiResponse['recentInnovations'] as List)
          .map((item) => InnovationModel.fromJson(item))
          .toList();
      await _storageService.saveToLocalStorage(
          recentInnovationsKey, jsonEncode(recentInnovations.map((e) => e.toJson()).toList()));
      var flashInnovations = (apiResponse['flashInnovations'] as List)
          .map((item) => InnovationModel.fromJson(item))
          .toList();
      var myInnovations = (apiResponse['myInnovations'] as List)
          .map((item) => InnovationModel.fromJson(item))
          .toList();
      var approvedInnovations = (apiResponse['approvedInnovations'] as List)
          .map((item) => InnovationModel.fromJson(item))
          .toList();
      final provider = Provider.of<SciKFProvider>(context, listen: false);
      await provider.updateAfterLogin(
        user: user,
        recentInnovations: recentInnovations,
        flashInnovations: flashInnovations,
        myInnovations: myInnovations,
        approvedInnovations: approvedInnovations,
      );

      return "Successfully logged in";
    } else {
      var message = jsonDecode(response.body);
      return "${message['msg']}";
    }
  }

  Future<void> reloadMainScreenData() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/Innovation/reload'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      final apiResponse = jsonDecode(response.body);
      var data = apiResponse;
      var recentInnovations = InnovationModel.fromJson(data.recentInnovations);
      await _storageService.saveToLocalStorage(recentInnovationsKey, jsonEncode(recentInnovations));
      var flashInnovations = InnovationModel.fromJson(data.flashInnovations);
      await _storageService.saveToLocalStorage(flashInnovationsKey, jsonEncode(flashInnovations));
    }
  }

  Future<List<ApplicationUser>> getAllUsers() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/User'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((item) => ApplicationUser.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch users: ${response.body}');
    }
  }

  Future<ApplicationUser> getUserById(String id) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/User/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return ApplicationUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

  Future<void> updateUser(String id, UpdateUserModel model) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/User/$id'),
      headers: _getHeaders(),
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/User/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }

  Future<List<InnovationModel>> getAllInnovations() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/Innovation/approved'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((item) => InnovationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch innovations: ${response.body}');
    }
  }

  Future<InnovationModel> getInnovationById(int id) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/Innovation/get/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return InnovationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch innovation: ${response.body}');
    }
  }

  Future<bool> createInnovation(InnovationDTO innovation, PlatformFile? file, PlatformFile? image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/Innovation/SaveInnovation'));
    request.fields['Title'] = innovation.title!;
    request.fields['Summary'] = innovation.summary!;
    request.fields['Category'] = innovation.category!.displayName;
    request.fields['AuthorId'] = innovation.authorId!;

    if (file != null && file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'File',
          file.bytes!,
          filename: file.name,
        ),
      );
    }

    if (image != null && image.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'DisplayImage',
          image.bytes!,
          filename: image.name,
        ),
      );
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> approveInnovation(int id) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/Innovation/approve/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to approve innovation: ${response.body}');
    }
  }

  Future<void> rejectInnovation(int id) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/Innovation/reject/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to reject innovation: ${response.body}');
    }
  }

  Future<List<InnovationModel>> getPendingInnovations() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/Innovation/pending'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      await _storageService.saveToLocalStorage(unapprovedInnovationsKey, jsonEncode(json));
      return json.map((item) => InnovationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch pending innovations: ${response.body}');
    }
  }

  Future<List<InnovationModel>> getLoggedInUserInnovations(String? userId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/Innovation/innovationByUserId/$userId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      await _storageService.saveToLocalStorage(myInnovationsKey, jsonEncode(json));
      return json.map((item) => InnovationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch pending innovations: ${response.body}');
    }
  }

  Future<void> updateInnovation(int id, InnovationModel innovation) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/Innovation/$id'),
      headers: _getHeaders(),
      body: jsonEncode(innovation.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update innovation: ${response.body}');
    }
  }

  Future<void> deleteInnovation(int id) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/Innovation/delete/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete innovation: ${response.body}');
    }
  }

  Future<List<InnovationModel>> searchInnovations({
    String? title,
    Category? category,
    String? author,
    String? summary,
  }) async {
    final queryParameters = {
      if (title != null) 'title': title,
      if (category != null) 'category': category.toString().split('.').last,
      if (author != null) 'author': author,
      if (summary != null) 'summary': summary,
    };

    final uri = Uri.parse('$baseUrl/Innovation/search').replace(queryParameters: queryParameters);
    final response = await _client.get(uri, headers: _getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((item) => InnovationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search innovations: ${response.body}');
    }
  }

  void dispose() {
    _client.close();
  }
}