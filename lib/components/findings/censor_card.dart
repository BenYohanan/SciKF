import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feeds/services/BaseHelperService.dart';
import 'package:news_feeds/services/storage_keys.dart';
import 'package:news_feeds/widgets/dialogs.dart';

import '../../constants.dart';
import '../../services/StorageService.dart';
import '../../size_config.dart';
import '../loader.dart';
import '../network_image_with_loader.dart';

class CensorCard extends ConsumerStatefulWidget {
  const CensorCard({
    super.key,
    required this.image,
    required this.category,
    required this.title,
    required this.author,
    required this.authorId,
    required this.id,
    this.date,
    this.status,
  });

  final String image, category, title, author, authorId;
  final String? date, status;
  final int id;

  @override
  ConsumerState<CensorCard> createState() => _CensorCardState();
}

class _CensorCardState extends ConsumerState<CensorCard> {
  BaseHelperService baseHelperService = BaseHelperService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: getProportionateScreenHeight(90),
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: Stack(
                    children: [
                      widget.image.isEmpty
                          ? Image.asset(
                        'assets/img/NoImg.png',
                        fit: BoxFit.cover,
                      )
                          : NetworkImageWithLoader(
                        widget.image,
                        radius: defaultBorderRadius,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(8),
                    vertical: getProportionateScreenHeight(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title.toUpperCase(),
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(10),
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(5)),
                      Text(
                        widget.category,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(12),
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(5)),
                      Text(
                        widget.author.isEmpty ? "" : "Author: ${widget.author}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      Row(
                        children: [
                          Text(
                            widget.status ?? '',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: defaultPadding / 4),
                          Text(
                            widget.date ?? '',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(4)),
                  child: ElevatedButton(
                    onPressed: () async {
                      AppLoader.show(context);
                      var myId = await StorageService().getFromLocalStorage(loginUserIdKey);
                      await baseHelperService.approveInnovation(widget.id);
                      await baseHelperService.reloadData(ref, myId!);
                      Navigator.pop(context);
                      Dialogs.flushBar(context, "Success", "Innovation Approved Successfully");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size(double.infinity, getProportionateScreenHeight(36)),
                      textStyle: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Approve"),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(4)),
                  child: ElevatedButton(
                    onPressed: () async {
                      AppLoader.show(context);
                      var myId = await StorageService().getFromLocalStorage(loginUserIdKey);
                      await baseHelperService.rejectInnovation(widget.id);
                      await baseHelperService.reloadData(ref, myId!);
                      Navigator.pop(context);
                      Dialogs.flushBar(context, "Success", "Innovation rejected Successfully");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size(double.infinity, getProportionateScreenHeight(36)),
                      textStyle: TextStyle(
                        fontSize: getProportionateScreenHeight(12),
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Reject"),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: primaryColor,
            thickness: 1,
            height: getProportionateScreenHeight(16),
          ),
        ],
      ),
    );
  }
}