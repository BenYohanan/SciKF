import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_bottom_nav_bar.dart';
import '../../../../components/findings/secondary_product_card.dart';
import '../../../../model/innovation_model.dart';
import '../../../components/skleton/others/discover_categories_skelton.dart';
import '../../../services/BaseHelperService.dart';
import '../../../services/StorageService.dart';
import '../../../services/storage_keys.dart';
import '../../../widgets/dialogs.dart';

class ApprovedInnovationsScreen extends StatefulWidget {
  const ApprovedInnovationsScreen({super.key});

  @override
  State<ApprovedInnovationsScreen> createState() => _ApprovedInnovationsScreenState();
}

class _ApprovedInnovationsScreenState extends State<ApprovedInnovationsScreen> {
  List<InnovationModel> approvedInnovations = [];
  var storageService = StorageService();
  var baseHelperService = BaseHelperService();
  bool _isLoading = false;

  Future<void> _loadApprovedInnovations({bool forceSync = false}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (!forceSync) {
        final String? cachedInnovationsJson = await storageService.getFromLocalStorage(approvedInnovationsKey);
        if (cachedInnovationsJson != null && cachedInnovationsJson != "null" && cachedInnovationsJson.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(cachedInnovationsJson);
          approvedInnovations = jsonList.map((json) => InnovationModel.fromJson(json)).toList();
        }
      }

      if (approvedInnovations.isEmpty && forceSync) {
        approvedInnovations = await baseHelperService.getPendingInnovations();
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          approvedInnovations = approvedInnovations;
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        await Dialogs.flushBar(context, "Error", "Failed to load innovations");
      }
    }
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  Future<void> _refreshData() async {
    await _loadApprovedInnovations(forceSync: true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(16)),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
                  child: Text(
                    "Innovations",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(20),
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const DiscoverCategoriesSkelton()
                      : approvedInnovations.isEmpty
                      ? const Center(child: Text("No innovations available"))
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: approvedInnovations.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: getProportionateScreenHeight(16)),
                          child: SecondaryFindingsCard(
                            image: approvedInnovations[index].image,
                            category: approvedInnovations[index].category,
                            title: approvedInnovations[index].title,
                            date: approvedInnovations[index].date,
                            status: approvedInnovations[index].status
                          ),
                        ),
                        Divider(
                          color: primaryColor,
                          thickness: 1,
                          height: getProportionateScreenHeight(16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}