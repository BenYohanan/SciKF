import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_bottom_nav_bar.dart';
import '../../../../components/findings/secondary_product_card.dart';
import '../../../../model/innovation_model.dart';
import '../../../services/BaseHelperService.dart';
import '../../../services/StorageService.dart';
import '../../../services/storage_keys.dart';
import '../../../widgets/dialogs.dart';
import 'innovation_details_screen.dart';

class ApprovedInnovationsScreen extends ConsumerStatefulWidget {
  const ApprovedInnovationsScreen({super.key});

  @override
  ConsumerState<ApprovedInnovationsScreen> createState() => _ApprovedInnovationsScreenState();
}

class _ApprovedInnovationsScreenState extends ConsumerState<ApprovedInnovationsScreen> {

  List<InnovationModel> approvedInnovations = [];
  bool isLoading = true;

  final storageService = StorageService();
  final baseHelperService = BaseHelperService();

  Future<void> _loadApprovedInnovations({bool forceSync = false}) async {
    try {

      if (!forceSync) {
        final cached = await storageService.getFromLocalStorage(approvedInnovationsKey);

        if (cached != null && cached != "null" && cached.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(cached);
          approvedInnovations =
              jsonList.map((e) => InnovationModel.fromJson(e)).toList();
        }
      }

      if (approvedInnovations.isEmpty || forceSync) {
        approvedInnovations = await baseHelperService.getAllInnovations();

        var userId = await storageService.getFromLocalStorage(loginUserIdKey);
        if (userId != null && userId.isNotEmpty) {
          await baseHelperService.reloadData(ref, userId);
        }else{
          await storageService.saveToLocalStorage(
            approvedInnovationsKey,
            jsonEncode(approvedInnovations.map((e) => e.toJson()).toList()),
          );
        }
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
    await _loadApprovedInnovations(forceSync: true);
  }

  @override
  void initState() {
    super.initState();
    _loadApprovedInnovations();
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
                : approvedInnovations.isEmpty
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

            Icon(Icons.auto_awesome,
                size: 80, color: Colors.grey.shade400),

            SizedBox(height: getProportionateScreenHeight(20)),

            Text(
              "No Approved Innovations",
              style: TextStyle(
                fontSize: getProportionateScreenHeight(18),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(10)),

            const Text(
              "There are no approved innovations yet.\nCheck back later.",
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
      itemCount: approvedInnovations.length,

      itemBuilder: (context, index) {
        final innovation = approvedInnovations[index];

        return Column(
          children: [

            Padding(
              padding: EdgeInsets.only(
                top: getProportionateScreenHeight(16),
              ),

              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InnovationDetailsScreen(
                            innovationModel: innovation,
                          ),
                    ),
                  );
                },

                child: SecondaryFindingsCard(
                  image: innovation.image,
                  category: innovation.category,
                  author: innovation.author,
                  title: innovation.title,
                  date: innovation.date,
                  status: innovation.status,
                  authorEmail: innovation.authorEmail,
                  innovationId: innovation.id!,
                  displayType: innovation.displayType,
                ),
              ),
            ),

            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: getProportionateScreenHeight(16),
            ),
          ],
        );
      },
    );
  }
}