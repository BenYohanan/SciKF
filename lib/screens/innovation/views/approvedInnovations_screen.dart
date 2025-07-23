import 'dart:convert';

import 'package:flutter/material.dart';
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

class ApprovedInnovationsScreen extends StatefulWidget {
  const ApprovedInnovationsScreen({super.key});

  @override
  State<ApprovedInnovationsScreen> createState() => _ApprovedInnovationsScreenState();
}

class _ApprovedInnovationsScreenState extends State<ApprovedInnovationsScreen> {
  List<InnovationModel> approvedInnovations = [];
  var storageService = StorageService();
  var baseHelperService = BaseHelperService();

  Future<void> _loadApprovedInnovations({bool forceSync = false}) async {
    try {
      if (!forceSync) {
        final String? cachedInnovationsJson = await storageService.getFromLocalStorage(approvedInnovationsKey);
        if (cachedInnovationsJson != null && cachedInnovationsJson != "null" && cachedInnovationsJson.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(cachedInnovationsJson);
          approvedInnovations = jsonList.map((json) => InnovationModel.fromJson(json)).toList();
        }
      }

      if (approvedInnovations.isEmpty || forceSync) {
        approvedInnovations = await baseHelperService.getAllInnovations();
      }
      if (mounted) {
        setState(() {
          approvedInnovations = approvedInnovations;
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        await Dialogs.flushBar(context, "Error", "Failed to load innovations");
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
                ), approvedInnovations.isEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: getProportionateScreenHeight(16)),
                              child: SecondaryFindingsCard(
                                image: "",
                                category: "",
                                author: "No Innovations Available",
                                title: "",
                                date: "",
                                status: "",
                                authorEmail: "",
                              ),
                            ),
                            Divider(
                              color: primaryColor,
                              thickness: 1,
                              height: getProportionateScreenHeight(16),
                            ),
                          ],
                        ),
                      )
                    :
                    ListView.builder(
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
                          author: approvedInnovations[index].author,
                          title: approvedInnovations[index].title,
                          date: approvedInnovations[index].date,
                          status: approvedInnovations[index].status,
                          authorEmail: approvedInnovations[index].authorEmail,
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}