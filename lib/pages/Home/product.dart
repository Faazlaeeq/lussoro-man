// ignore_for_file: must_be_immutable, prefer_const_constructors, unrelated_type_equality_checks, unused_import, prefer_final_fields, camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/pages/authentication/login.dart';
import 'package:single_ecommerce/model/cart/qtyupdatemodel.dart';
import 'package:single_ecommerce/model/favorite/addtocartmodel.dart';
import 'package:single_ecommerce/model/home/itemdetailsmodel.dart';
import 'package:single_ecommerce/routes/route_manager.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart';
import 'package:single_ecommerce/widgets/border_test_widget.dart';
import 'package:single_ecommerce/widgets/counter_widget.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:single_ecommerce/common%20class/allformater.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/common%20class/icons.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:single_ecommerce/pages/favorite/showvariation.dart';
import 'package:single_ecommerce/pages/Home/Homepage.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import '../cart/cartpage.dart';
import 'package:single_ecommerce/widgets/my_appbar_widget.dart';

class buttoncontroller extends GetxController {
  RxInt _variationselecationindex = 0.obs;
}

class Product extends StatefulWidget {
  int? itemid;

  @override
  State<Product> createState() => _ProductState();
  Product([
    this.itemid,
  ]);
}

class _ProductState extends State<Product> {
  String? userid = "";
  String? sessionid;
  String? is_login;
  int? cart;
  itemdetailsmodel? itemdata;
  buttoncontroller select = Get.put(buttoncontroller());
  cartcount count = Get.put(cartcount());
  bool? isproductdetail = true;
  String? currency;
  String? currency_position;
  List<String> arr_addonsid = [];
  List<String> arr_addonsname = [];
  List<String> arr_addonsprice = [];

  @override
  void initState() {
    super.initState();
  }

  addtocartmodel? addtocartdata;
  addtocart(itemid, itemname, itemimage, itemtype, itemtax, itemprice) async {
    try {
      loader.showLoading();
      var map;
      if (userid == "" || userid == null) {
        map = {
          "session_id": sessionid,
          "item_id": itemid,
          "item_name": itemname,
          "item_image": itemimage,
          "item_type": itemtype,
          "tax": itemtax,
          "item_price": numberFormat.format(double.parse(itemprice)),
          "variation_id": "",
          "variation": "",
          "addons_id": "",
          "addons_name": "",
          "addons_price": "",
          "addons_total_price": numberFormat.format(double.parse("0")),
        };
      } else {
        map = {
          "user_id": userid,
          "item_id": itemid,
          "item_name": itemname,
          "item_image": itemimage,
          "item_type": itemtype,
          "tax": itemtax,
          "item_price": numberFormat.format(double.parse(itemprice)),
          "variation_id": "",
          "variation": "",
          "addons_id": "",
          "addons_name": "",
          "addons_price": "",
          "addons_total_price": numberFormat.format(double.parse("0")),
        };
      }
      print(map);

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);
      print(response);
      addtocartdata = addtocartmodel.fromJson(response.data);
      if (addtocartdata!.status == 1) {
        isproductdetail = true;
        loader.hideLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(APPcart_count, addtocartdata!.cartCount.toString());

        count.cartcountnumber(int.parse(prefs.getString(APPcart_count)!));
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future itemdetailsAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = (prefs.getString(UD_user_id) ?? "");
    sessionid = prefs.getString(UD_user_session_id);
    is_login = prefs.getString(UD_user_is_login_required);
    currency = (prefs.getString(APPcurrency) ?? "");
    currency_position = (prefs.getString(APPcurrency_position) ?? "");
    loader.showLoading();
    try {
      var map;

      if (userid == "" || userid == null) {
        map = {
          "session_id": sessionid ?? "",
          "item_id": widget.itemid,
        };
      } else {
        map = {
          "user_id": userid ?? "",
          "item_id": widget.itemid,
        };
      }

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Itemdetails, data: map);

      isproductdetail = false;

      itemdata = itemdetailsmodel.fromJson(response.data);
      loader.hideLoading();
      return itemdata;
    } catch (e) {
      rethrow;
    }
  }

  removefavarite(String isfavorite, String itemid) async {
    try {
      loader.showLoading();
      var map = {"user_id": userid, "item_id": itemid, "type": isfavorite};
      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.Managefavorite, data: map);
      var finaldata = QTYupdatemodel.fromJson(response.data);
      if (finaldata.status == 1) {
        setState(() {
          isproductdetail = true;
        });

        loader.hideLoading();
      }
    } catch (e) {
      rethrow;
    }
  }

  CounterWidget counterWidget = CounterWidget();

  add_to_cartAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double addonstotalprice = 0;
    for (int i = 0; i < arr_addonsprice.length; i++) {
      addonstotalprice = addonstotalprice + double.parse(arr_addonsprice[i]);
    }
    try {
      var map;
      loader.showLoading();
      if (userid == "" || userid == null) {
        map = {
          "session_id": sessionid,
          "item_id": itemdata!.data!.id,
          "item_name": itemdata!.data!.itemName,
          "item_image": itemdata!.data!.itemImages![0].imageName,
          "item_type": itemdata!.data!.itemType,
          "tax": numberFormat.format(double.parse(
            itemdata!.data!.tax,
          )),
          "item_price": itemdata!.data!.hasVariation == "1"
              ? numberFormat.format(double.parse(itemdata!
                  .data!
                  .variation![
                      int.parse(select._variationselecationindex.toString())]
                  .productPrice!))
              : numberFormat.format(double.parse(itemdata!.data!.price!)),
          "variation_id": itemdata!.data!.hasVariation == "1"
              ? itemdata!
                  .data!
                  .variation![
                      int.parse(select._variationselecationindex.toString())]
                  .id
              : "",
          "variation": itemdata!.data!.hasVariation == "1"
              ? itemdata!
                  .data!
                  .variation![
                      int.parse(select._variationselecationindex.toString())]
                  .variation
              : "",
          "addons_id": arr_addonsid.join(","),
          "addons_name": arr_addonsname.join(","),
          "addons_price": arr_addonsprice.join(","),
          "addons_total_price": numberFormat.format(addonstotalprice),
        };
      } else {
        map = {
          "user_id": userid,
          "item_id": itemdata!.data!.id,
          "item_name": itemdata!.data!.itemName,
          "item_image": itemdata!.data!.itemImages![0].imageName,
          "item_type": itemdata!.data!.itemType,
          "tax": numberFormat.format(double.parse(
            itemdata!.data!.tax,
          )),
          "item_price": itemdata!.data!.hasVariation == "1"
              ? numberFormat.format(double.parse(itemdata!
                  .data!
                  .variation![
                      int.parse(select._variationselecationindex.toString())]
                  .productPrice!))
              : numberFormat.format(double.parse(itemdata!.data!.price!)),
          "variation_id": itemdata!.data!.hasVariation == "1"
              ? itemdata!
                  .data!
                  .variation![
                      int.parse(select._variationselecationindex.toString())]
                  .id
              : "",
          "variation": itemdata!.data!.hasVariation == "1"
              ? itemdata!
                  .data!
                  .variation![
                      int.parse(select._variationselecationindex.toString())]
                  .variation
              : "",
          "addons_id": arr_addonsid.join(","),
          "addons_name": arr_addonsname.join(","),
          "addons_price": arr_addonsprice.join(","),
          "addons_total_price": numberFormat.format(addonstotalprice),
        };
      }

      print(map);

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);
      print(response);
      var finaldata = addtocartmodel.fromJson(response.data);
      if (finaldata.status == 1) {
        loader.hideLoading();

        prefs.setString(APPcart_count, finaldata.cartCount.toString());
        count.cartcountnumber.value =
            (int.parse(prefs.getString(APPcart_count)!));

        setState(() {
          isproductdetail = true;
          select._variationselecationindex(0);
        });
      }
    } catch (e) {
      loader.hideLoading();
      print(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: isproductdetail == true ? itemdetailsAPI() : null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: color.primarycolor,
                ),
              ),
            );
          }

          var oldAppBar = AppBar(
            title: const Text(
              "Product Dispay",
              style: TextStyle(fontFamily: 'Poppins_semibold'),
            ),
            centerTitle: true,
            actions: [
              if (is_login == "1") ...[
                Positioned(
                  right: 3.w,
                  top: 1.h,
                  child: Container(
                    height: 5.5.h,
                    width: 5.5.h,
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.height / 80),
                    // margin: EdgeInsets.only(left: 86.w, top: 1.5.h),
                    decoration: BoxDecoration(
                      // shape: BoxShape.values,
                      borderRadius: BorderRadius.circular(6),
                      color: color.black,
                    ),
                    child: InkWell(
                      onTap: () {
                        if (userid == "") {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (c) => Login()),
                              (r) => false);
                        } else if (itemdata!.data!.isFavorite == "0") {
                          removefavarite("favorite", widget.itemid.toString());
                        } else {
                          removefavarite(
                              "unfavorite", widget.itemid.toString());
                        }
                      },
                      child: itemdata!.data!.isFavorite == "0"
                          ? SvgPicture.asset(
                              'Assets/Icons/Favorite.svg',
                              color: Colors.white,
                            )
                          : SvgPicture.asset(
                              'Assets/Icons/Favoritedark.svg',
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ]
            ],
          );
          var textButton = TextButton(
            child: Obx(() => count.cartcountnumber == 0
                ? Text(
                    'Viewcart'.tr,
                    style: TextStyle(
                        fontFamily: 'Poppins_semibold',
                        color: color.darkblack,
                        fontSize: 14.sp),
                  )
                : Text(
                    "${'Viewcart'.tr}(${count.cartcountnumber.value.toString()})",
                    style: TextStyle(
                        fontFamily: 'Poppins_semibold',
                        color: color.primarycolor,
                        fontSize: 14.sp),
                  )),
            onPressed: () {
              // if (userid == "") {
              //   Navigator.of(context).pushAndRemoveUntil(
              //       MaterialPageRoute(builder: (c) => Login()),
              //       (r) => false);
              // } else {
              if (is_login == "1") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage(2)),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage(1)),
                );
              }
              // }
            },
          );
          Text priceWidget = (itemdata!.data!.hasVariation == "1")
              ? Text(
                  currency_position == "1"
                      ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![0].productPrice.toString()))}"
                      : "${numberFormat.format(double.parse(itemdata!.data!.variation![0].productPrice.toString()))}$currency",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18),
                )
              : Text(
                  currency_position == "1"
                      ? "$currency${numberFormat.format(double.parse(itemdata!.data!.price.toString()))}"
                      : "${numberFormat.format(double.parse(itemdata!.data!.price.toString()))}$currency",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18),
                );

          return Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 50.h,
                                  width: 100.w,
                                  child: Image.network(
                                    itemdata!.data!.itemImages![0].imageUrl
                                        .toString(),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                // if (is_login == "1") ...[
                                Positioned(
                                  right: 3.w,
                                  bottom: 3.h,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    padding: EdgeInsets.all(padding1),
                                    // margin: EdgeInsets.only(left: 86.w, top: 1.5.h),

                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: MyColors.shadowColor,
                                          blurRadius: 7,
                                          spreadRadius: 1,
                                        )
                                      ],
                                      // shape: BoxShape.values,
                                      borderRadius: BorderRadius.circular(15),
                                      color: MyColors.secondaryColor,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (userid == "") {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (c) => Login()),
                                                  (r) => false);
                                        } else if (itemdata!.data!.isFavorite ==
                                            "0") {
                                          removefavarite("favorite",
                                              widget.itemid.toString());
                                        } else {
                                          removefavarite("unfavorite",
                                              widget.itemid.toString());
                                        }
                                      },
                                      child: itemdata!.data!.isFavorite == "0"
                                          ? Image.asset(
                                              'Assets/Icons/favorite.png',
                                              // color: Colors.white,
                                            )
                                          : Image.asset(
                                              'Assets/Icons/favorite-filled.png',
                                              // color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(padding5),
                              decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: MyColors.shadowColor,
                                        blurRadius: 7,
                                        spreadRadius: 1,
                                        offset: Offset(0, -10))
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  color: MyColors.secondaryColor),
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: width(context) * 0.9,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 45,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    itemdata!.data!.itemName
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                  Text(
                                                      itemdata!
                                                          .data!
                                                          .categoryInfo!
                                                          .categoryName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall),

                                                  //outof stock
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                if (itemdata!.data!
                                                            .availableQty ==
                                                        "" ||
                                                    int.parse(itemdata!
                                                            .data!.availableQty
                                                            .toString()) <=
                                                        0) ...[
                                                  Text('Out_of_Stock'.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            fontSize: 11,
                                                            fontFamily:
                                                                'Poppins_medium',
                                                          )),
                                                ] else if (itemdata!
                                                            .data!.tax ==
                                                        "" ||
                                                    itemdata!.data!.tax ==
                                                        "0") ...[
                                                  Text(
                                                      'Inclusive_of_all_taxes'
                                                          .tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            fontSize: 11,
                                                            fontFamily:
                                                                'Poppins_medium',
                                                          )),
                                                ] else ...[
                                                  Text(
                                                      "${itemdata!.data!.tax}% ${'additional_tax'.tr}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            fontSize: 11,
                                                            fontFamily:
                                                                'Poppins_medium',
                                                          )),
                                                ],
                                                Text(
                                                    itemdata!
                                                        .data!.preparationTime,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Desctiption",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          (itemdata!.data!.itemDescription ==
                                                      "" ||
                                                  itemdata!.data!
                                                          .itemDescription ==
                                                      null)
                                              ? " - "
                                              : itemdata!.data!.itemDescription,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                  fontFamily:
                                                      'Poppins-regular'),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      if (itemdata!.data!.hasVariation ==
                                          "1") ...[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              left: 4.w,
                                              top: 2.h,
                                              bottom: 1.h,
                                              right: 4.w),
                                          child: Text(
                                            itemdata!.data!.attribute!,
                                            style: TextStyle(
                                                fontFamily: 'Poppins_bold',
                                                fontSize: 15.sp),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.all(0),
                                          height: itemdata!
                                                  .data!.variation!.length *
                                              6.5.h,
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: itemdata!
                                                .data!.variation!.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.w,
                                                    bottom: 1.h,
                                                    right: 5.w),
                                                child: InkWell(
                                                  onTap: () {
                                                    select
                                                        ._variationselecationindex(
                                                            index);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Obx(
                                                        () => Container(
                                                          height: 3.3.h,
                                                          width: 3.3.h,
                                                          decoration: BoxDecoration(
                                                              color: select
                                                                          ._variationselecationindex ==
                                                                      index
                                                                  ? color.black
                                                                  : Colors
                                                                      .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              border: Border.all(
                                                                  color: color
                                                                      .black)),
                                                          child: Icon(
                                                              Icons.done,
                                                              color: select
                                                                          ._variationselecationindex ==
                                                                      index
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .transparent,
                                                              size: 13.sp),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (itemdata!
                                                                      .data!
                                                                      .variation![
                                                                          index]
                                                                      .availableQty ==
                                                                  "" ||
                                                              int.parse(itemdata!
                                                                      .data!
                                                                      .variation![
                                                                          index]
                                                                      .availableQty
                                                                      .toString()) <=
                                                                  0) ...[
                                                            Text(
                                                              itemdata!
                                                                  .data!
                                                                  .variation![
                                                                      index]
                                                                  .variation!,
                                                              style: TextStyle(
                                                                fontSize: 11.sp,
                                                                fontFamily:
                                                                    'Poppins_semibold',
                                                                color:
                                                                    color.grey,
                                                              ),
                                                            ),
                                                            Text(
                                                              currency_position ==
                                                                      "1"
                                                                  ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))} ${'Out_of_Stock'.tr}"
                                                                  : "${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}$currency ${'Out_of_Stock'.tr}",
                                                              style: TextStyle(
                                                                fontSize: 8.sp,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color:
                                                                    color.grey,
                                                              ),
                                                            )
                                                          ] else ...[
                                                            Text(
                                                              itemdata!
                                                                  .data!
                                                                  .variation![
                                                                      index]
                                                                  .variation!,
                                                              style: TextStyle(
                                                                fontSize: 11.sp,
                                                                fontFamily:
                                                                    'Poppins_semibold',
                                                              ),
                                                            ),
                                                            Text(
                                                              currency_position ==
                                                                      "1"
                                                                  ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}"
                                                                  : "${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}$currency",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      8.sp,
                                                                  fontFamily:
                                                                      'Poppins'),
                                                            )
                                                          ]
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                      SizedBox(
                                        height: 80,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ])),

                  //appbar
                  Positioned(
                    top: 1.h,
                    left: 3.w,
                    child: Container(
                      // margin: EdgeInsets.only(left: 2.5.w, top: 1.5.h),
                      decoration: BoxDecoration(
                        // shape: BoxShape.values,
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        icon: ImageIcon(
                          AssetImage("Assets/Icons/arrow-smooth-left.png"),
                          color: MyColors.secondaryColor,
                          size: 17,
                        ),
                        style: ButtonStyle(
                            backgroundColor: MyColors.mPrimaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  // textButton,
                  Positioned(
                    top: 1.h,
                    right: 3.w,
                    child: Stack(
                      children: [
                        Positioned(
                            top: 5,
                            right: 5,
                            child: Obx(() => (count.cartcountnumber != 0)
                                ? Badge(
                                    label: Text(
                                        count.cartcountnumber.value.toString()),
                                  )
                                : SizedBox())),
                        IconButton(
                          onPressed: () {
                            if (is_login == "1") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage(2)),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage(1)),
                              );
                            }
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: MyColors.shadowColor,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: CircleAvatar(
                                backgroundColor: MyColors.secondaryColor,
                                child: Padding(
                                  padding: EdgeInsets.all(padding2),
                                  child: Image(
                                      image: AssetImage(
                                          "Assets/Icons/cartbag.png"),
                                      alignment: Alignment.bottomCenter,
                                      fit: BoxFit.cover),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //appbar
                ],
              ),
              //navigation button Cart
              bottomSheet: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: padding3),
                tileColor: MyColors.secondaryColor,
                title: Text("Total Price",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 9)),
                subtitle: priceWidget,
                trailing: ElevatedButton(
                  child: SizedBox(
                    width: width(context) * .35,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage("Assets/Icons/addtocart.png"),
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Add to Cart",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: MyColors.secondaryColor),
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RoutesManager.cart);
                  },
                ),
              ));
        },
      ),
    );
  }

  Container addAndViewCartbutton(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 8.h,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.darkblack,
              ),
            ),
            height: 6.5.h,
            width: 47.w,
            child: TextButton(
              child: Obx(() => count.cartcountnumber == 0
                  ? Text(
                      'Viewcart'.tr,
                      style: TextStyle(
                          fontFamily: 'Poppins_semibold',
                          color: color.darkblack,
                          fontSize: 14.sp),
                    )
                  : Text(
                      "${'Viewcart'.tr}(${count.cartcountnumber.value.toString()})",
                      style: TextStyle(
                          fontFamily: 'Poppins_semibold',
                          color: color.primarycolor,
                          fontSize: 14.sp),
                    )),
              onPressed: () {
                // if (userid == "") {
                //   Navigator.of(context).pushAndRemoveUntil(
                //       MaterialPageRoute(builder: (c) => Login()),
                //       (r) => false);
                // } else {
                if (is_login == "1") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage(2)),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage(1)),
                  );
                }
                // }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.green,
              ),
            ),
            height: 6.5.h,
            width: 47.w,
            child: TextButton(
              onPressed: () {
                // if (userid == "") {
                //   Navigator.of(context).pushAndRemoveUntil(
                //       MaterialPageRoute(builder: (c) => Login()),
                //       (r) => false);
                // } else {
                //   if (itemdata!
                //               .data!
                //               .variation![select
                //                   ._variationselecationindex
                //                   .value]
                //               .availableQty ==
                //           "" ||
                //       int.parse(itemdata!
                //               .data!
                //               .variation![select
                //                   ._variationselecationindex
                //                   .value]
                //               .availableQty
                //               .toString()) <=
                //           0) {
                //     loader.showErroDialog(
                //       description: "Product is out of stock",
                //     );
                //   } else {
                arr_addonsid.clear();
                arr_addonsname.clear();
                arr_addonsprice.clear();
                for (int i = 0; i < itemdata!.data!.addons!.length; i++) {
                  if (itemdata!.data!.addons![i].isselected == true) {
                    arr_addonsid.add(itemdata!.data!.addons![i].id.toString());
                    arr_addonsname
                        .add(itemdata!.data!.addons![i].name.toString());
                    arr_addonsprice.add(numberFormat.format(double.parse(
                        itemdata!.data!.addons![i].price.toString())));
                  }
                }
                print("sdfghjkl");
                add_to_cartAPI();
                // }
                // }
              },
              style: TextButton.styleFrom(
                backgroundColor: color.green,
              ),
              child: Text(
                'Add_to_cart'.tr,
                style: TextStyle(
                    fontFamily: 'Poppins_semibold',
                    color: Colors.white,
                    fontSize: 14.sp),
              ),
            ),
          ),
        ]));
  }
}
