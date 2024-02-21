import 'package:flutter/material.dart';
import 'package:single_ecommerce/routes/route_manager.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart';

class CommonWidgets {
  static Widget headingText(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
      ),
    );
  }

  static Widget roundedButton({
    required BuildContext context,
    required String text,
    required double widthInPercent,
    VoidCallback? onPressed,
    String? routeName,
    double borderRadius = 25,
    Widget? preffixIcon,
  }) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ))),
      onPressed: onPressed ??
          () {
            Navigator.of(context).pushNamed(routeName!);
          },
      child: SizedBox(
        width: width(context) * (widthInPercent / 100),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            preffixIcon ?? const SizedBox(),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: MyColors.secondaryColor),
            )
          ],
        ),
      ),
    );
  }

  static Widget customListTile({
    required BuildContext context,
    ImageProvider? imageUrl,
    String? name,
    String? subtitle,
    Widget? titleEnd,
    String? description,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    TextStyle? subtitleStyle,
    double? heightImg,
    double? widthImg,
    bool isDecoratedCard = true,
    double imageBorderRadius = 10,
    TextStyle? nameTheme,
    double verticalPadding = padding1,
    double horizontalPadding = padding1,
    BoxFit? fit,
    Alignment imageAlignment = Alignment.center,
    Widget? discriptionWidget,
    bool haveShadow = true,
    Color tileColor = Colors.transparent,
  }) {
    return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: padding2, vertical: padding2),
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: isDecoratedCard
            ? BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(13),
                boxShadow: haveShadow ? const [MyColors.spreadedShadow] : [],
              )
            : const BoxDecoration(),
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          children: [
            imageUrl == null
                ? const SizedBox()
                : Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageBorderRadius),
                        image: DecorationImage(
                            alignment: imageAlignment,
                            image: imageUrl,
                            fit: fit ?? BoxFit.cover)),
                    height: heightImg ?? 60,
                    width: widthImg ?? 60,
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: padding2, vertical: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name ?? "",
                                style: nameTheme ??
                                    Theme.of(context).textTheme.titleSmall!),
                            SizedBox(child: titleEnd)
                          ],
                        ),
                      ),
                      subtitle == null
                          ? const SizedBox()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                subtitle,
                                style: subtitleStyle ??
                                    Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.subtitleColor2),
                              ),
                            ),
                      description == null
                          ? const SizedBox()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                description,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: MyColors.primaryColor),
                              ),
                            ),
                      discriptionWidget ?? const SizedBox()
                    ]),
              ),
            ),
          ],
        ));
  }

  static Widget listTileWithButton(
      {required BuildContext context,
      String? iconUrl,
      String? title,
      String? subtitle,
      String? buttonText,
      VoidCallback? onPressed}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Text(title ?? "Total Price",
          style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 9)),
      subtitle: subtitle == null
          ? const SizedBox()
          : Text(
              subtitle,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
            ),
      trailing: ElevatedButton(
        onPressed: onPressed ??
            () {
              Navigator.of(context).pushNamed(RoutesManager.cart);
            },
        child: SizedBox(
          width: width(context) * .35,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconUrl == null
                  ? const SizedBox()
                  : ImageIcon(
                      AssetImage(iconUrl),
                      size: 16,
                    ),
              const SizedBox(
                width: 10,
              ),
              Text(
                buttonText ?? "Add to Cart",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: MyColors.secondaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget searchBarWithIconButton({
    String text = "Search",
    String imageUrl = "Assets/Icons/search.png",
    required BuildContext context,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: padding3),
              padding: const EdgeInsets.symmetric(horizontal: padding3),
              height: 50,
              decoration: BoxDecoration(
                color: MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: MyColors.outlineColorOnLight,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage(imageUrl),
                    color: MyColors.primaryColor,
                    size: 17,
                  ),
                  const SizedBox(width: padding3),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: text,
                        hintStyle: Theme.of(context).textTheme.labelLarge,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: MyColors.primaryColor,
              ),
              child: const Padding(
                padding: EdgeInsets.all(padding3),
                child: ImageIcon(
                  AssetImage("Assets/Icons/search.png"),
                  size: 18,
                  color: MyColors.secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
