import 'package:flutter/material.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color?> getImagePalette(ImageProvider provider) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(
    provider,
  );

  return paletteGenerator.lightMutedColor?.color;
}

Widget productCard(BuildContext context, String image, String title,
    String subTitle, String price, Function()? onTap) {
  return SizedBox(
    width: width(context) * 0.4,
    child: Column(
      children: [
        Stack(children: [
          FutureBuilder<Color?>(
            future: getImagePalette(NetworkImage(image)),
            builder: (BuildContext context, AsyncSnapshot<Color?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Container(
                    height: 170,
                    width: width(context) * 0.4,
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: snapshot.data ?? MyColors.secondaryColor,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(image),
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: MyColors.shadowColor,
                              blurRadius: 5,
                              spreadRadius: 3)
                        ]),
                  );
                }
              }
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Image.asset(
                "Assets/Icons/love.png",
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
                height: 20,
                width: 20,
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
    ),
  );
}
