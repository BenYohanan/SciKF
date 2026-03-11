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

  final StorageService storageService = StorageService();
  final BaseHelperService baseHelperService = BaseHelperService();

  bool _isLoading = false;

  Future<void> _loadPendingInnovations({bool forceSync = false}) async {

    setState(() {
      _isLoading = true;
    });

    try {

      if (!forceSync) {

        final cachedJobsJson =
        await storageService.getFromLocalStorage(unapprovedInnovationsKey);

        if (cachedJobsJson != null &&
            cachedJobsJson != "null" &&
            cachedJobsJson.isNotEmpty) {

          final List<dynamic> jsonList = jsonDecode(cachedJobsJson);

          pendingInnovations =
              jsonList.map((json) => InnovationModel.fromJson(json)).toList();
        }
      }

      if (pendingInnovations.isEmpty || forceSync) {

        pendingInnovations = await baseHelperService.getPendingInnovations();

        var userId =
        await storageService.getFromLocalStorage(loginUserIdKey);

        await baseHelperService.reloadData(ref, userId!);
      }

      if (mounted) {
        setState(() {});
      }

    } catch (e) {

      if (mounted) {
        Navigator.pop(context);

        await Dialogs.flushBar(
          context,
          "Error",
          "Failed to load innovations: $e",
        );
      }

    } finally {

      if (mounted) {
        setState(() {
          _isLoading = false;
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
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(16),
            ),

            child: ListView(
              children: [

                Padding(
                  padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(8),
                  ),

                  child: Text(
                    "Censor Innovations",

                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(20),
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                pendingInnovations.isEmpty
                    ? _emptyView()
                    : _innovationList(),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _emptyView() {

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1,

      itemBuilder: (context, index) {

        return Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenHeight(16),
          ),

          child: CensorCard(
            image: "",
            category: "",
            author: "",
            authorId: "",
            title: "No Innovations Available",
            status: "",
            id: 0,
          ),
        );
      },
    );
  }

  Widget _innovationList() {

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pendingInnovations.length,

      itemBuilder: (context, index) {

        final innovation = pendingInnovations[index];

        return CensorCard(
          image: innovation.image,
          category: innovation.category,
          title: innovation.title,
          author: innovation.author,
          authorId: innovation.authorId ?? "",
          date: innovation.date,
          status: innovation.status,
          id: innovation.id!,
        );
      },
    );
  }
}