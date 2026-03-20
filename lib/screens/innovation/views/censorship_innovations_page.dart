import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import '../../../components/findings/censor_card.dart';
import '../../../constants.dart';
import '../../../model/innovation_model.dart';
import '../../../services/BaseHelperService.dart';
import '../../../services/StorageService.dart';
import '../../../services/storage_keys.dart';
import '../../../size_config.dart';
import '../../../widgets/dialogs.dart';

class CensorshipInnovationsScreen extends ConsumerStatefulWidget {
  const CensorshipInnovationsScreen({super.key});

  @override
  ConsumerState<CensorshipInnovationsScreen> createState() =>
      _CensorshipInnovationsScreenState();
}

class _CensorshipInnovationsScreenState
    extends ConsumerState<CensorshipInnovationsScreen> {

  List<InnovationModel> pendingInnovations = [];
  bool isLoading = true;

  final StorageService storageService = StorageService();
  final BaseHelperService baseHelperService = BaseHelperService();

  Future<void> _loadPendingInnovations({bool forceSync = false}) async {
    try {

      if (!forceSync) {
        final cached =
        await storageService.getFromLocalStorage(unapprovedInnovationsKey);

        if (cached != null && cached != "null" && cached.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(cached);
          pendingInnovations =
              jsonList.map((e) => InnovationModel.fromJson(e)).toList();
        }
      }

      if (pendingInnovations.isEmpty || forceSync) {
        pendingInnovations =
        await baseHelperService.getPendingInnovations();

        var userId =
        await storageService.getFromLocalStorage(loginUserIdKey);

        await baseHelperService.reloadData(ref, userId!);
      }

    } catch (e) {
      if (mounted) {
        await Dialogs.flushBar(
          context,
          "Error",
          "Failed to load innovations",
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadPendingInnovations(forceSync: true);
  }

  @override
  void initState() {
    super.initState();
    _loadPendingInnovations();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),

      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _refreshData,

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor,))
                : pendingInnovations.isEmpty
                ? _emptyView()
                : _innovationList(),
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _emptyView() {
    return ListView(
      children: [
        SizedBox(height: getProportionateScreenHeight(80)),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(Icons.verified_outlined,
                size: 80, color: Colors.grey.shade400),

            SizedBox(height: getProportionateScreenHeight(20)),

            Text(
              "All Caught Up",
              style: TextStyle(
                fontSize: getProportionateScreenHeight(18),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(10)),

            const Text(
              "There are no innovations pending review.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _innovationList() {
    return ListView.builder(
      itemCount: pendingInnovations.length,

      itemBuilder: (context, index) {
        final innovation = pendingInnovations[index];

        return Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenHeight(16),
          ),

          child: CensorCard(
            image: innovation.image,
            category: innovation.category,
            title: innovation.title,
            author: innovation.author,
            authorId: innovation.authorId ?? "",
            date: innovation.date,
            status: innovation.status,
            id: innovation.id!,
          ),
        );
      },
    );
  }
}