import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/model/innovation_model.dart';
import 'package:news_feeds/size_config.dart';

import '../../../components/network_image_with_loader.dart';
import '../../../constants.dart';
import 'components/innovation_info.dart';

class InnovationDetailsScreen extends StatelessWidget {
  InnovationDetailsScreen({
    super.key,
    required this.innovationModel,
  });
    final InnovationModel innovationModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadius * 2),
                        ),
                        child: innovationModel.image.isEmpty
                            ? Image.asset('assets/img/NoImg.png', fit: BoxFit.cover)
                            : NetworkImageWithLoader(innovationModel.image),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InnovationInfo(
              author: innovationModel.author,
              title: innovationModel.title,
              description: innovationModel.summary!,
              category:  innovationModel.category
            ),
          ],
        ),
      ),
    );
  }
}
