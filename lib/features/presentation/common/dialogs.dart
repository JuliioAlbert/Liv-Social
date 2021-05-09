import 'package:flutter/material.dart';
import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/core/theme/pallete_color.dart';
import 'package:liv_social/features/presentation/common/spin_loading_indicator.dart';
import 'package:liv_social/core/extension/string_extension.dart';

Future<bool?> confirmation(
  BuildContext context,
  String title,
  String label,
  String cancel,
  String actionText,
  VoidCallback action,
) async {
  return await showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        title: Center(
            child: Text(title,
                style: const TextStyle(color: PalleteColor.actionButtonColor))),
        content: Text(
          label,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancel,
              style: const TextStyle(color: PalleteColor.actionButtonColor),
            ),
          ),
          TextButton(
            onPressed: action,
            child: Text(actionText,
                style: const TextStyle(color: PalleteColor.actionButtonColor)),
          )
        ],
      );
    },
  );
}

void loading(
  BuildContext context,
  String message, {
  bool isBlocked = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => !isBlocked,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 100.0, child: SpinLoadingIndicator()),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(message, textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

void alertMessage(
  BuildContext context,
  String title,
  String label, {
  String? extraActionText,
  VoidCallback? extraAction,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: PalleteColor.titleTextColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          label,
          textAlign: TextAlign.center,
        ),
        actionsOverflowButtonSpacing: 0,
        actionsOverflowDirection: VerticalDirection.up,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (extraAction != null && extraActionText != null)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      extraAction();
                    },
                    child: Text(
                      extraActionText,
                      style: const TextStyle(
                          color: PalleteColor.actionButtonColor),
                    ),
                  ),
                const SizedBox(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(Keys.accept.localize(),
                      style: const TextStyle(
                          color: PalleteColor.titleTextColor,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      );
    },
  );
}
