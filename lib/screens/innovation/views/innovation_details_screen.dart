import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../components/innovation_action_button.dart';
import '../../../constants.dart';
import 'components/product_images.dart';
import 'components/innovation_info.dart';

class InnovationDetailsScreen extends StatelessWidget {
  const InnovationDetailsScreen({super.key, this.isAdmin = true});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isAdmin
          ? InnovationActionButton(
        onAccept: () {},
        onReject: () {},
      )
          : null,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
            const ProductImages(
              images: [productDemoImg1, productDemoImg2, productDemoImg3],
            ),
            InnovationInfo(
              author: "Broad Institute",
              title: "CRISPR-Cas9 Gene Editing Breakthrough",
              description:
              "CRISPR-Cas9 technology has revolutionized genetic engineering, enabling precise edits to DNA to treat diseases like sickle cell anemia. Developed by leading researchers, this tool is transforming medicine and biotechnology.",
            ),
          ],
        ),
      ),
    );
  }
}
