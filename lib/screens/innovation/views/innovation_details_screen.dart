import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/model/innovation_model.dart';
import 'package:news_feeds/size_config.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import '../../../components/network_image_with_loader.dart';
import '../../../components/pdf_viewer_screen.dart';
import '../../../constants.dart';
import '../../../services/download_helper.dart';

class InnovationDetailsScreen extends StatelessWidget {
  const InnovationDetailsScreen({
    super.key,
    required this.innovationModel,
  });

  final InnovationModel innovationModel;

  @override
  Widget build(BuildContext context) {
    final hasFile =
        innovationModel.fileUrl != null &&
            innovationModel.fileUrl!.isNotEmpty;

    final isPdf =
        hasFile && innovationModel.fileUrl!.toLowerCase().endsWith(".pdf");

    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  "assets/icons/Bookmark.svg",
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, color: Colors.black),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  innovationModel.image.isEmpty
                      ? Image.asset(
                    'assets/img/NoImg.png',
                    fit: BoxFit.cover,
                  )
                      : NetworkImageWithLoader(
                    innovationModel.image,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (innovationModel.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        innovationModel.category,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: getProportionateScreenHeight(10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  SizedBox(height: getProportionateScreenHeight(8)),

                  Text(
                    innovationModel.title,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(18),
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  SizedBox(height: getProportionateScreenHeight(8)),

                  if (innovationModel.author.isNotEmpty)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: primaryColor.withOpacity(0.2),
                          child: Text(
                            innovationModel.author[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          innovationModel.author,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(10),
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: getProportionateScreenHeight(14)),

                  if (innovationModel.summary != null &&
                      innovationModel.summary!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(12),
                            color: primaryColor
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          innovationModel.summary!,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(14),
                            height: 1.6,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: getProportionateScreenHeight(16)),
                  if (hasFile)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Attachment",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(12),
                            color: primaryColor
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (isPdf) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PdfViewerScreen(
                                              url: innovationModel.fileUrl!,
                                            ),
                                      ),
                                    );
                                  } else {
                                    downloadFile(
                                        innovationModel.fileUrl!, context);
                                  }
                                },
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text("View"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(8)),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await downloadFile(
                                    innovationModel.fileUrl!,
                                    context,
                                  );
                                },
                                icon: const Icon(Icons.download, size: 16),
                                label: const Text("Download"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}