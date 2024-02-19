// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, avoid_types_as_parameter_names, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_ecommerce/model/home/homescreenmodel.dart';
import 'package:single_ecommerce/pages/Home/categoriesinfo.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:single_ecommerce/widgets/my_bottom_navigationbar.dart';
import 'package:sizer/sizer.dart';

class Categoriespage extends StatefulWidget {
  List<Categories>? categoriesdata;

  @override
  State<Categoriespage> createState() => _CategoriespageState();
  Categoriespage([this.categoriesdata]);
}

class _CategoriespageState extends State<Categoriespage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 20,
            )),
        title: Text(
          'Categories'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins_semibold', fontSize: 11.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: padding5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Categories",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: padding3,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height(context) * .69),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return CategoryTile(
                    icon: widget.categoriesdata![index].image.toString(),
                    title:
                        widget.categoriesdata![index].categoryName.toString(),
                    subTitle: "",
                  );
                },
                itemCount: widget.categoriesdata!.length,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(key: scaffoldKey),
    ));
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    this.title = "New Arrival",
    this.subTitle = "208 Products",
    this.icon = "assets/icons/new-arrival.png",
  });
  final String icon;
  final String title;
  final String subTitle;
  // final List<ProductCard> items;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: width(context),
      margin: const EdgeInsets.symmetric(vertical: padding1),
      padding: const EdgeInsets.symmetric(horizontal: padding3),
      decoration: BoxDecoration(
          color: MyColors.primaryColor,
          borderRadius: BorderRadius.circular(50)),
      child: InkWell(
        onTap: () {
          // Navigator.of(context)
          //     .pushNamed(RoutesManager.productsByCat, arguments: items);
        },
        child: Row(
          children: [
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                icon,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: padding3,
            ),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: MyColors.secondaryColor)),
            const Expanded(child: SizedBox()),
            Text("See Products  ",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: MyColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-regular'))
          ],
        ),
      ),
    );
  }
}
