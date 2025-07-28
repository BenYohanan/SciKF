import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_bottom_nav_bar.dart';
import '../../../../components/findings/secondary_product_card.dart';
import '../../../../model/innovation_model.dart';
import '../../../../services/BaseHelperService.dart';
import '../../../../services/StorageService.dart';
import '../../../../services/storage_keys.dart';
import '../../../../widgets/dialogs.dart';
import '../innovation_details_screen.dart';

class MyInnovationScreen extends StatefulWidget {
  const MyInnovationScreen({super.key});

  @override
  State<MyInnovationScreen> createState() => _MyInnovationScreenState();
}

class _MyInnovationScreenState extends State<MyInnovationScreen> {
  List<InnovationModel> findings = [];
  var storageService = StorageService();
  var baseHelperService = BaseHelperService();

  Future<void> _loadMyInnovations({bool forceSync = false}) async {
    try {
      if (!forceSync) {
        final String? cachedInnovationsJson = await storageService.getFromLocalStorage(myInnovationsKey);
        if (cachedInnovationsJson != null && cachedInnovationsJson != "null" && cachedInnovationsJson.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(cachedInnovationsJson);
          findings = jsonList.map((json) => InnovationModel.fromJson(json)).toList();
        }
      }

      if (findings.isEmpty || forceSync) {
        var userId = await storageService.getFromLocalStorage(loginUserIdKey);
        findings = await baseHelperService.getLoggedInUserInnovations(userId!);
        await baseHelperService.ReloadData(context, userId);
      }
      if (mounted) {
        setState(() {

          findings = findings;
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
    await _loadMyInnovations(forceSync: true);
  }

  @override
  void initState() {
    super.initState();
    _loadMyInnovations();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
                  child: Text(
                    "My Innovations",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(20),
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                findings.isEmpty
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
                            author: "",
                            title: "Add your first innovation",
                        ),
                      )
                    ],
                  ),
                )
                    :
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: findings.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: getProportionateScreenHeight(16)),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InnovationDetailsScreen(innovationModel: findings[index]),
                              ),
                            );
                          },
                          child: SecondaryFindingsCard(
                            image: findings[index].image,
                            category: findings[index].category,
                            author: findings[index].author,
                            title: findings[index].title,
                            date: findings[index].date,
                            status: findings[index].status,
                            authorEmail: findings[index].authorEmail,
                          ),
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