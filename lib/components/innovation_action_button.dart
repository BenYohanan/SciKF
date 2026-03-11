import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class InnovationActionButton extends StatelessWidget {
  const InnovationActionButton({
    super.key,
    required this.onAccept,
    required this.onReject,
  });

  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultBorderRadius / 2,
        ),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: primaryColor,
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(defaultBorderRadius),
                    ),
                  ),
                  child: InkWell(
                    onTap: onAccept,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Accept",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenHeight(16),
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Material(
                  color: Colors.grey[600], // Different color for Reject
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(defaultBorderRadius),
                    ),
                  ),
                  child: InkWell(
                    onTap: onReject,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Reject",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenHeight(16),
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}