import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/size_config.dart';

import '../../constants.dart';
import '../../providers/sci_kf_notifier.dart';
import '../../providers/service_providers.dart';
import '../../services/BaseHelperService.dart';
import '../../widgets/dialogs.dart';
import '../loader.dart';
import '../network_image_with_loader.dart';

class SecondaryFindingsCard extends ConsumerWidget {
  const SecondaryFindingsCard({
    super.key,
    required this.image,
    required this.category,
    required this.title,
    required this.author,
    this.date,
    this.status,
    this.authorEmail,
    required this.innovationId,
    this.displayType
  });

  final String image, category, title, author;
  final String? date, status, authorEmail, displayType;
  final int innovationId;

  String get normalizedType => (displayType ?? "").toLowerCase();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sciKFProvider).user;
    final isAdmin = user?.isAdmin == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: image.isEmpty
                        ? Image.asset(
                      'assets/img/NoImg.png',
                      fit: BoxFit.cover,
                    )
                        : NetworkImageWithLoader(image),
                  ),
                ),
              ),

              SizedBox(width: getProportionateScreenHeight(10)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(14),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    SizedBox(height: getProportionateScreenHeight(4)),

                    if (category.isNotEmpty)
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(12),
                          color: Colors.grey.shade600,
                        ),
                      ),

                    SizedBox(height: getProportionateScreenHeight(4)),

                    if (author.isNotEmpty)
                      Text(
                        "By $author",
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(10)),
                      ),

                    SizedBox(height: getProportionateScreenHeight(4)),

                    if (authorEmail != null && authorEmail!.isNotEmpty)
                      Text(
                        authorEmail!,
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(10),
                          color: Colors.grey.shade500,
                        ),
                      ),

                    SizedBox(height: getProportionateScreenHeight(6)),

                    Row(
                      children: [
                        if (status != null && status!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status!,
                              style: TextStyle(
                                fontSize:
                                getProportionateScreenHeight(10),
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        if (status != null && status!.isNotEmpty)
                          SizedBox(
                              width:
                              getProportionateScreenHeight(6)),

                        if (date != null && date!.isNotEmpty)
                          Text(
                            date!,
                            style: TextStyle(
                              fontSize:
                              getProportionateScreenHeight(10),
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isAdmin) ...[
            SizedBox(height: getProportionateScreenHeight(10)),
            if (displayType != null && displayType!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: normalizedType == "flash"
                          ? Colors.green.withOpacity(0.1)
                          : normalizedType == "hotpick"
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      normalizedType == "flash"
                          ? "⚡ Flash"
                          : normalizedType == "hotpick"
                          ? "🔥 Hot"
                          : "Normal",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: normalizedType == "flash"
                            ? Colors.green
                            : normalizedType== "hotpick"
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

            Row(
              children: [
                if (normalizedType != "flash")
                  Expanded(
                    child: _actionButton(
                      label: "Flash",
                      icon: "assets/icons/Star.svg",
                      color: Colors.green,
                      onTap: () async {
                        await _updateType(context, ref, innovationId, 2);
                      },
                    ),
                  ),

                if (normalizedType != "flash" && normalizedType != "hotpick")
                  SizedBox(width: getProportionateScreenWidth(6)),
                if (normalizedType != "hotpick")
                  Expanded(
                    child: _actionButton(
                      label: "Hot",
                      icon: "assets/icons/Doublecheck.svg",
                      color: Colors.red,
                      onTap: () async {
                        await _updateType(context, ref, innovationId, 1);
                      },
                    ),
                  ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: color),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            height: 14,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _updateType(
      BuildContext context,
      WidgetRef ref,
      int id,
      int type,
      ) async {
    final service = ref.read(baseHelperServiceProvider);

    try {
      AppLoader.show(context);

      await service.updateInnovationType(id, type);

      if (!context.mounted) return;

      Navigator.pop(context);

      Dialogs.flushBar(context, "Holla Admin", "Updated to $type");

      final userId = ref.read(sciKFProvider).user?.id ?? '';

      await service.reloadData(ref, userId);

    } catch (e) {
      if (!context.mounted) return;

      Navigator.pop(context);

      Dialogs.flushBar(context, "Holla Admin", "Update failed");
    }
  }
}