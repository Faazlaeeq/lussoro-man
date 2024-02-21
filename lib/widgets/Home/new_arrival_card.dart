import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:http/http.dart' as http;

// Future<Color?> getImagePalette(ImageProvider provider) async {
//   final PaletteGenerator paletteGenerator =
//       await PaletteGenerator.fromImageProvider(provider,
//           region: const Rect.fromLTWH(0, 0, 10, 10), size: const Size(10, 10));

//   return paletteGenerator.lightMutedColor?.color;
// }

Widget productCard(BuildContext context, String image, String title,
    String subTitle, String price, Function()? onTap,
    {String icon = "Assets/Icons/love.png"}) {
  return SizedBox(
      width: width(context) * 0.4,
      child: Column(
        children: [
          Stack(children: [
            Container(
                height: 170,
                width: width(context) * 0.4,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: MyColors.secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      image,
                    ),
                  ),
                  // boxShadow: const [
                  //   BoxShadow(
                  //       color: MyColors.shadowColor,
                  //       blurRadius: 5,
                  //       spreadRadius: 3)
                  // ]
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Image.asset(
                  icon,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.cover,
                  height: 30,
                  width: 30,
                ),
                onPressed: onTap,
              ),
            ),
          ]),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
            // overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          Text(subTitle, style: Theme.of(context).textTheme.labelSmall),
          Text("\$$price", style: Theme.of(context).textTheme.titleSmall!),
        ],
      ));
}
