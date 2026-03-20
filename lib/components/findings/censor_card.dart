import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../../services/BaseHelperService.dart';
import '../../services/StorageService.dart';
import '../../services/storage_keys.dart';
import '../../size_config.dart';
import '../../widgets/dialogs.dart';
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
  final BaseHelperService baseHelperService = BaseHelperService();
  bool isProcessing = false;

  Future<void> _handleAction({
    required String action,
    required Future<void> Function() apiCall,
    required String successMessage,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$action Innovation"),
        content: Text("Are you sure you want to $action this innovation?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isProcessing = true);

    try {
      var myId = await StorageService().getFromLocalStorage(loginUserIdKey);

      await apiCall();

      await baseHelperService.reloadData(ref, myId!);

      Dialogs.flushBar(context, "Success", successMessage);
    } catch (e) {
      Dialogs.flushBar(context, "Error", "Something went wrong");
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: widget.image.isEmpty
                      ? Image.asset('assets/img/NoImg.png', fit: BoxFit.cover)
                      : NetworkImageWithLoader(widget.image),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: getProportionateScreenWidth(13),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    Text( "Category: ${widget.category}",
                      style: TextStyle(color: Colors.grey, fontSize: getProportionateScreenHeight(11)),
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    Text(
                      "By ${widget.author}",
                      style: TextStyle(fontSize: getProportionateScreenHeight(10)),
                    ),
                    SizedBox(height: getProportionateScreenHeight(6)),
                    Row(
                      children: [
                        if (widget.status != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.status!,
                              style: TextStyle(
                                fontSize: 10,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        SizedBox(width: getProportionateScreenWidth(8)),
                        Text(
                          widget.date ?? '',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          if (isProcessing)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: "Approve",
                    icon: "assets/icons/Approve.svg",
                    color: Colors.green,
                    onTap: () => _handleAction(
                      action: "Approve",
                      apiCall: () =>
                          baseHelperService.approveInnovation(widget.id),
                      successMessage: "Innovation Approved",
                    ),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(8)),
                Expanded(
                  child: _actionButton(
                    label: "Reject",
                    icon: "assets/icons/Reject.svg",
                    color: Colors.red,
                    onTap: () => _handleAction(
                      action: "Reject",
                      apiCall: () =>
                          baseHelperService.rejectInnovation(widget.id),
                      successMessage: "Innovation Rejected",
                    ),
                  ),
                ),
              ],
            ),
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
}