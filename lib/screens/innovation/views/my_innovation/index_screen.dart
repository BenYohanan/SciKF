import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_bottom_nav_bar.dart';
import '../../../../components/findings/secondary_product_card.dart';
import '../../../../model/innovation_model.dart';
import '../../../../route/route_constants.dart';
import '../../../../services/BaseHelperService.dart';
import '../../../../services/StorageService.dart';
import '../../../../services/storage_keys.dart';
import '../../../../widgets/dialogs.dart';
import '../innovation_details_screen.dart';

class MyInnovationScreen extends ConsumerStatefulWidget {
  const MyInnovationScreen({super.key});

  @override
  ConsumerState<MyInnovationScreen> createState() => _MyInnovationScreenState();
}

class _MyInnovationScreenState extends ConsumerState<MyInnovationScreen> {

  List<InnovationModel> findings = [];
  bool isLoading = true;

  final StorageService storageService = StorageService();
  final BaseHelperService baseHelperService = BaseHelperService();

  Future<void> _loadMyInnovations({bool forceSync = false}) async {
    try {

      if (!forceSync) {
        final cached = await storageService.getFromLocalStorage(myInnovationsKey);

        if (cached != null && cached != "null" && cached.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(cached);
          findings = jsonList.map((e) => InnovationModel.fromJson(e)).toList();
        }
      }

      if (findings.isEmpty || forceSync) {
        var userId = await storageService.getFromLocalStorage(loginUserIdKey);

        findings = await baseHelperService.getLoggedInUserInnovations(userId!);

        await baseHelperService.reloadData(ref, userId);
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
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor,))
                : findings.isEmpty
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

            Icon(Icons.lightbulb_outline,
                size: 80, color: Colors.grey.shade400),

            SizedBox(height: getProportionateScreenHeight(20)),

            Text(
              "No Innovations Yet",
              style: TextStyle(
                fontSize: getProportionateScreenHeight(18),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(10)),

            const Text(
              "You haven’t submitted any innovation yet.\nStart by adding your first idea.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, postAnInnovationScreenRoute);
              },
              child: const Text("Add Innovation"),
            )
          ],
        ),
      ],
    );
  }

  Widget _innovationList() {
    return ListView.builder(
      itemCount: findings.length,

      itemBuilder: (context, index) {
        final innovation = findings[index];

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