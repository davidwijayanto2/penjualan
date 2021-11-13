import 'package:flutter/material.dart';
import 'package:penjualan/utils/common_widgets.dart';

import 'common_text.dart';
import 'my_colors.dart';

class PopupDialog {
  final BuildContext context;

  final String? titleText;
  final String? subtitleText;

  final String? rightButtonText;
  final String? leftButtonText;
  final Function(BuildContext)? rightButtonAction;
  final Function()? leftButtonAction;
  final Color rightButtonColor;

  final IconData? icon;
  final Color iconColor;

  final bool singleButton;
  final bool barrierDismissible;
  final double borderRadius;

  final Function()? showCallBack;
  final Function()? dismissCallBack;

  get isShowing => _isShowing;
  bool _isShowing = false;

  bool useRootNavigator = true;

  PopupDialog({
    required this.context,
    this.titleText,
    this.subtitleText,
    this.rightButtonText,
    this.leftButtonText,
    this.rightButtonAction,
    this.leftButtonAction,
    this.rightButtonColor = MyColors.themeColor1,
    this.icon,
    this.iconColor = MyColors.orange,
    this.barrierDismissible = true,
    this.showCallBack,
    this.singleButton = false,
    this.dismissCallBack,
    this.borderRadius = 16.0,
  }) {
    this.show();
  }

  show() {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        backgroundColor: MyColors.white,
        insetPadding: EdgeInsets.all(16),
        contentPadding: EdgeInsets.zero,
        content: PopupDialogBuilder(
          contentPadding: 28.0,
          singleButton: singleButton,
          icon: icon,
          iconColor: iconColor,
          titleText: titleText,
          subtitleText: subtitleText,
          rightButtonText: rightButtonText,
          rightButtonAction: rightButtonAction,
          rightButtonColor: rightButtonColor,
          leftButtonText: leftButtonText,
          leftButtonAction: leftButtonAction,
          isShowingChange: (bool isShowingChange) {
            // showing or dismiss Callback
            if (isShowingChange) {
              if (showCallBack != null) {
                showCallBack!();
              }
            } else {
              if (dismissCallBack != null) {
                dismissCallBack!();
              }
            }
            _isShowing = isShowingChange;
          },
        ),
      ),
    );
  }

  void dismiss() {
    if (_isShowing) {
      Navigator.of(this.context, rootNavigator: useRootNavigator).pop();
    }
  }
}

class PopupDialogBuilder extends StatefulWidget {
  final String? titleText;
  final String? subtitleText;

  final String? rightButtonText;
  final String? leftButtonText;
  final Function(BuildContext)? rightButtonAction;
  final Function()? leftButtonAction;
  final Color? rightButtonColor;

  final IconData? icon;
  final Color? iconColor;

  final bool? singleButton;
  final double contentPadding;
  final Function(bool) isShowingChange;

  const PopupDialogBuilder({
    required this.isShowingChange,
    required this.contentPadding,
    this.titleText,
    this.subtitleText,
    this.rightButtonText,
    this.leftButtonText,
    this.rightButtonAction,
    this.leftButtonAction,
    this.rightButtonColor,
    this.icon,
    this.iconColor,
    this.singleButton,
  });

  @override
  _PopupDialogBuilderState createState() => _PopupDialogBuilderState();
}

class _PopupDialogBuilderState extends State<PopupDialogBuilder> {
  @override
  void dispose() {
    widget.isShowingChange(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.isShowingChange(true);

    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.contentPadding),
      child: ListBody(
        children: <Widget>[
          if (widget.icon != null)
            Icon(
              widget.icon,
              size: 40,
              color: widget.iconColor,
            ),
          if (widget.icon != null)
            SizedBox(
              height: 20,
            ),
          if (widget.titleText != null)
            CommonText.text(
              text: widget.titleText!,
              style: CommonText.title(color: MyColors.black),
              align: TextAlign.center,
            ),
          if (widget.titleText != null)
            SizedBox(
              height: 16,
            ),
          if (widget.subtitleText != null)
            CommonText.text(
              text: widget.subtitleText!,
              style: CommonText.body1(color: MyColors.black),
              align: TextAlign.center,
            ),
          if (widget.subtitleText != null)
            SizedBox(
              height: 20,
            ),
          Row(
            children: <Widget>[
              if (!widget.singleButton!)
                Expanded(
                  child: CommonWidgets.outlinedButton(
                    text: widget.leftButtonText != null
                        ? widget.leftButtonText!.toUpperCase()
                        : "CANCEL",
                    onPressed: widget.leftButtonAction ??
                        () => Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ),
              if (!widget.singleButton!)
                SizedBox(
                  width: 10,
                ),
              Expanded(
                child: CommonWidgets.containedButton(
                  text: widget.rightButtonText != null
                      ? widget.rightButtonText!.toUpperCase()
                      : "OK",
                  backgroundColor: widget.rightButtonColor,
                  onPressed: widget.rightButtonAction != null
                      ? () => widget.rightButtonAction!(context)
                      : () => Navigator.of(context, rootNavigator: true).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// PopupDialogWithWidgetSubtitle ====================================================

class PopupDialogWithWidgetSubtitle {
  final BuildContext context;

  final String? titleText;
  final Widget? subtitleTextWidget;

  final String? rightButtonText;
  final String? leftButtonText;
  final Function()? rightButtonAction;
  final Function()? leftButtonAction;
  final Color rightButtonColor;

  final IconData? icon;
  final Color iconColor;

  final bool singleButton;
  final bool barrierDismissible;
  final double borderRadius;

  final Function()? showCallBack;
  final Function()? dismissCallBack;

  get isShowing => _isShowing;
  bool _isShowing = false;

  bool useRootNavigator = true;

  PopupDialogWithWidgetSubtitle({
    required this.context,
    this.titleText,
    this.subtitleTextWidget,
    this.rightButtonText,
    this.leftButtonText,
    this.rightButtonAction,
    this.leftButtonAction,
    this.rightButtonColor = MyColors.themeColor1,
    this.icon,
    this.iconColor = MyColors.orange,
    this.singleButton = false,
    this.barrierDismissible = true,
    this.borderRadius = 16,
    this.showCallBack,
    this.dismissCallBack,
  }) {
    this.show();
  }

  show() {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        backgroundColor: MyColors.white,
        insetPadding: EdgeInsets.all(16),
        contentPadding: EdgeInsets.zero,
        content: PopupDialogWithWidgetSubtitleBuilder(
          contentPadding: 28.0,
          singleButton: singleButton,
          icon: icon,
          iconColor: iconColor,
          titleText: titleText,
          subtitleTextWidget: subtitleTextWidget,
          rightButtonText: rightButtonText,
          rightButtonAction: rightButtonAction,
          rightButtonColor: rightButtonColor,
          leftButtonText: leftButtonText,
          leftButtonAction: leftButtonAction,
          isShowingChange: (bool isShowingChange) {
            // showing or dismiss Callback
            if (isShowingChange) {
              if (showCallBack != null) {
                showCallBack!();
              }
            } else {
              if (dismissCallBack != null) {
                dismissCallBack!();
              }
            }
            _isShowing = isShowingChange;
          },
        ),
      ),
    );
  }

  void dismiss() {
    if (_isShowing) {
      Navigator.of(this.context, rootNavigator: useRootNavigator).pop();
    }
  }
}

class PopupDialogWithWidgetSubtitleBuilder extends StatefulWidget {
  final String? titleText;
  final Widget? subtitleTextWidget;

  final String? rightButtonText;
  final String? leftButtonText;
  final Function()? rightButtonAction;
  final Function()? leftButtonAction;
  final Color? rightButtonColor;

  final IconData? icon;
  final Color? iconColor;

  final bool? singleButton;
  final double contentPadding;
  final Function(bool) isShowingChange;

  const PopupDialogWithWidgetSubtitleBuilder({
    Key? key,
    this.titleText,
    this.subtitleTextWidget,
    this.rightButtonText,
    this.leftButtonText,
    this.rightButtonAction,
    this.leftButtonAction,
    this.rightButtonColor,
    this.icon,
    this.iconColor,
    this.singleButton,
    required this.contentPadding,
    required this.isShowingChange,
  }) : super(key: key);

  @override
  _PopupDialogWithWidgetSubtitleBuilderState createState() =>
      _PopupDialogWithWidgetSubtitleBuilderState();
}

class _PopupDialogWithWidgetSubtitleBuilderState
    extends State<PopupDialogWithWidgetSubtitleBuilder> {
  @override
  void dispose() {
    widget.isShowingChange(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.isShowingChange(true);

    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.contentPadding),
      child: ListBody(children: [
        if (widget.icon != null)
          Icon(
            widget.icon,
            size: 40,
            color: widget.iconColor,
          ),
        if (widget.icon != null)
          SizedBox(
            height: 20,
          ),
        if (widget.titleText != null)
          CommonText.text(
            text: widget.titleText!,
            style: CommonText.title(color: MyColors.black),
            align: TextAlign.center,
          ),
        if (widget.titleText != null)
          SizedBox(
            height: 16,
          ),
        if (widget.subtitleTextWidget != null) widget.subtitleTextWidget!,
        if (widget.subtitleTextWidget != null)
          SizedBox(
            height: 20,
          ),
        Row(
          children: <Widget>[
            if (!widget.singleButton!)
              Expanded(
                child: CommonWidgets.outlinedButton(
                  text: widget.leftButtonText != null
                      ? widget.leftButtonText!.toUpperCase()
                      : "CANCEL",
                  onPressed: widget.leftButtonAction ??
                      () => Navigator.of(context, rootNavigator: true).pop(),
                ),
              ),
            if (!widget.singleButton!)
              SizedBox(
                width: 10,
              ),
            Expanded(
              child: CommonWidgets.containedButton(
                text: widget.rightButtonText != null
                    ? widget.rightButtonText!.toUpperCase()
                    : "OK",
                backgroundColor: widget.rightButtonColor,
                onPressed: widget.rightButtonAction ??
                    () => Navigator.of(context, rootNavigator: true).pop(),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
