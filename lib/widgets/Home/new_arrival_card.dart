import 'package:flutter/material.dart';
import 'package:single_ecommerce/theme/sizes.dart';

Widget productCard(BuildContext context, String image, String title,
    String subTitle, String price) {
  return Column(
    children: [
      Stack(children: [
        Container(
          height: 170,
          width: width(context) * 0.4,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image:
                  DecorationImage(fit: BoxFit.cover, image: AssetImage(image))),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Image.asset(
              "assets/icons/love.png",
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
              height: 20,
              width: 20,
            ),
            onPressed: () {},
          ),
        ),
      ]),
      Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      Text(subTitle, style: Theme.of(context).textTheme.labelSmall),
      Text("\$$price", style: Theme.of(context).textTheme.titleSmall!),
    ],
  );
}
