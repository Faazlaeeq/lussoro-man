import 'package:flutter/material.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({
    super.key,
    required this.scaffoldKey,
    this.leadingIcon = 'assets/icons/drawer-icon.png',
    this.actionIcon = "assets/images/avatar.png",
    this.actionBgColor = MyColors.accentColorDark,
    this.padding = padding1,
    this.onpressed,
    this.positionedWidget,
    this.showTrailingIcon = false,
    this.onActionPressed,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String leadingIcon;
  final String actionIcon;
  final Color actionBgColor;
  final double padding;
  final Widget? positionedWidget;
  final bool showTrailingIcon;
  final VoidCallback? onpressed;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      surfaceTintColor: MyColors.forgroundWhiteColor,
      shadowColor: MyColors.shadowColor,
      scrolledUnderElevation: 10,
      leadingWidth: 90,
      leading: IconButton(
        icon: ImageIcon(
          AssetImage(leadingIcon),
          color: MyColors.secondaryColor,
          size: 17,
        ),
        style: ButtonStyle(backgroundColor: MyColors.mPrimaryColor),
        onPressed: onpressed ??
            () => {
                  if (scaffoldKey.currentState!.isDrawerOpen)
                    {scaffoldKey.currentState!.closeDrawer()}
                  else
                    {scaffoldKey.currentState!.openDrawer()}
                },
      ),
      actions: showTrailingIcon
          ? [
              Stack(
                children: [
                  positionedWidget ?? const SizedBox(),
                  IconButton(
                    onPressed: onActionPressed,
                    icon: CircleAvatar(
                        backgroundColor: actionBgColor,
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Image.asset(actionIcon,
                              alignment: Alignment.bottomCenter,
                              fit: BoxFit.cover),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                width: padding5,
              )
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
