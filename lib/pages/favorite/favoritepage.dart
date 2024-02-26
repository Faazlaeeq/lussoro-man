// ignore_for_file: prefer_const_constructors, avoid_print, unrelated_type_equality_checks, use_build_context_synchronously, non_constant_identifier_names, unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:single_ecommerce/model/cart/qtyupdatemodel.dart';
import 'package:single_ecommerce/model/favorite/addtocartmodel.dart';
import 'package:single_ecommerce/model/favorite/favoritelistmodel.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:single_ecommerce/common%20class/allformater.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/pages/favorite/showvariation.dart';
import 'package:single_ecommerce/pages/Home/Homepage.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? userid;
  favoritelistmodel? favoritedata;
  addtocartmodel? addtocartdata;
  cartcount count = Get.put(cartcount());
  int? cart;
  String? currency;
  String? currency_position;
  String icon = "Assets/Icons/Star-filled.png";

  FavoriteAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(UD_user_id);
    currency = prefs.getString(APPcurrency);
    currency_position = prefs.getString(APPcurrency_position);
    try {
      var map = {"user_id": userid};

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Favoritelist, data: map);
      print(response);
      favoritedata = favoritelistmodel.fromJson(response.data);
      print(favoritedata!.data!.length);

      if (favoritedata!.status == 1) {
        return favoritedata;
      } else {
        loader.showErroDialog(description: favoritedata!.message);
      }
    } catch (e) {
      print(e);
    }
  }

  addtocart(int? selectedindex) async {
    loader.showLoading();
    try {
      var map = {
        "user_id": userid,
        "item_id": favoritedata!.data![selectedindex!].id,
        "item_name": favoritedata!.data![selectedindex].itemName,
        "item_image": favoritedata!.data![selectedindex].imageName,
        "item_type": favoritedata!.data![selectedindex].itemType,
        "tax": favoritedata!.data![selectedindex].tax,
        "item_price": numberFormat
            .format(double.parse(favoritedata!.data![selectedindex].price!)),
        "variation_id": "",
        "variation": "",
        "addons_id": "",
        "addons_name": "",
        "addons_price": "",
        "addons_total_price": numberFormat.format(double.parse("0")),
      };
      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);
      addtocartdata = addtocartmodel.fromJson(response.data);
      loader.hideLoading();
      if (addtocartdata!.status == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(APPcart_count, addtocartdata!.cartCount.toString());
        count.cartcountnumber(int.parse(prefs.getString(APPcart_count)!));

        setState(() {
          FavoriteAPI();
        });
      } else {
        loader.showErroDialog(description: addtocartdata!.message);
      }

      print(map);
    } catch (e) {
      print(e);
    }
  }

  variationaddonsadd_to_cartAPI(int? itemindex, int? variationindex) async {
    try {
      var map = {
        "user_id": userid,
        "item_id": favoritedata!.data![itemindex!].id,
        "item_name": favoritedata!.data![itemindex].itemName,
        "item_image": favoritedata!.data![itemindex].imageName,
        "item_type": favoritedata!.data![itemindex].itemType,
        "tax": numberFormat.format(double.parse(
          favoritedata!.data![itemindex].tax!,
        )),
        "item_price": numberFormat
            .format(double.parse(favoritedata!.data![itemindex].price!)),
        "variation_id": favoritedata!.data![itemindex].hasVariation == "1"
            ? favoritedata!.data![itemindex].variation![variationindex!].id
            : "",
        "variation": favoritedata!.data![itemindex].hasVariation == "1"
            ? favoritedata!
                .data![itemindex].variation![variationindex!].variation
            : "",
        "addons_id": "",
        "addons_name": "",
        "addons_price": "",
        "addons_total_price": numberFormat.format(double.parse("0")),
      };
    } catch (e) {
      print(e);
    }
  }

  removefavorite(itemid) async {
    try {
      loader.showLoading();
      var map = {"user_id": userid, "item_id": itemid, "type": "unfavorite"};
      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.Managefavorite, data: map);
      var finaldata = QTYupdatemodel.fromJson(response.data);
      setState(() {
        favoritedata!.data!.remove(itemid);
      });
      loader.hideLoading();
      if (finaldata.status == 1) {
        loader.hideLoading();
      } else {
        loader.showErroDialog(description: finaldata.message);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              leadingWidth: 40,
              elevation: 0,
              title: Text(
                'Favorite_list'.tr,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontFamily: 'Poppins_semibold', fontSize: 12.sp),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: FutureBuilder(
              future: FavoriteAPI(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (favoritedata!.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No_data_found'.tr,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.sp,
                            color: Colors.grey),
                      ),
                    );
                  }
                  return StatefulBuilder(
                      builder: (context, setState) => ListView.builder(
                            itemCount: favoritedata!.data!.length,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(
                                top: 0.7.h,
                                bottom: 0.7.h,
                                left: 3.5.w,
                                right: 3.5.w,
                              ),
                              height: 14.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color:Color.fromARGB(255, 248, 248, 248),
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 0.8.sp,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Row(children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: 28.w,
                                        height: 15.5.h,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: Image(
                                              image: NetworkImage(
                                                favoritedata!
                                                    .data![index].imageUrl
                                                    .toString(),
                                              ),
                                              fit: BoxFit.contain,
                                            )),
                                      ),
                                      if (favoritedata!
                                              .data![index].hasVariation ==
                                          "0") ...[
                                        if (favoritedata!.data![index]
                                                    .availableQty ==
                                                "" ||
                                            int.parse(favoritedata!
                                                    .data![index].availableQty
                                                    .toString()) <=
                                                0) ...[
                                          Positioned(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 15.5.h,
                                              width: 28.w,
                                              color: Colors.black38,
                                              child: Text(
                                                'Out_of_Stock'.tr,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      'poppins_semibold',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
//removefavoraite
                                      Positioned(
                                        top: 3,
                                        right: 1,
                                          child: InkWell(
                                        onTap: () {
                                          removefavorite(
                                              favoritedata!.data![index].id);
                                        },
                                        child:  Container(
                  height: 25,
                  width: 25,
                 decoration: BoxDecoration(
                    color: MyColors.secondaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: MyColors.shadowColor,
                          blurRadius: 5,
                          spreadRadius: 3)
                    ]
                  ),
                  padding:EdgeInsets.all(5),
                  child: Image.asset(
                    icon,
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.cover,
                    height: 15,
                    width: 15,
                  ),
                ),
                                      )),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 0.5.h,
                                            left: 2.2.w,
                                            right: 2.2.w,
                                          ),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  favoritedata!
                                                      .data![index].itemName!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12.5.sp,
                                                    fontFamily:
                                                        'Poppins_semibold',
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
           //category info                           
                                       
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 2.2.w,
                                            right: 2.2.w,
                                          ),
                                          child: Text(
                                            favoritedata!.data![index]
                                                .categoryInfo!.categoryName!,
                                            style: TextStyle(
                                              fontSize: 7.5.sp,
                                              fontFamily: 'Poppins',
                                              color: color.green,
                                            ),
                                          ),
                                        ),
           //currency info                             
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 2.2.w,
                                              right: 2.2.w,
                                              bottom: 0.8.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              if (favoritedata!.data![index]
                                                      .hasVariation ==
                                                  "1") ...[
                                                Text(
                                                  currency_position == "1"
                                                      ? "$currency${numberFormat.format(
                                                          double.parse(
                                                              favoritedata!
                                                                  .data![index]
                                                                  .variation![0]
                                                                  .productPrice
                                                                  .toString()),
                                                        )}"
                                                      : "${numberFormat.format(
                                                          double.parse(
                                                              favoritedata!
                                                                  .data![index]
                                                                  .variation![0]
                                                                  .productPrice
                                                                  .toString()),
                                                        )}$currency",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily:
                                                        'Poppins_semibold',
                                                  ),
                                                )
                                              ] else if (favoritedata!
                                                      .data![index]
                                                      .hasVariation ==
                                                  "2") ...[
                                                Text(
                                                  currency_position == "1"
                                                      ? "$currency${numberFormat.format(
                                                          double.parse(
                                                              favoritedata!
                                                                  .data![index]
                                                                  .price!),
                                                        )}"
                                                      : "${numberFormat.format(
                                                          double.parse(
                                                              favoritedata!
                                                                  .data![index]
                                                                  .price!),
                                                        )}$currency",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily:
                                                        'Poppins_semibold',
                                                  ),
                                                )
                                              ],
                                              Spacer(),
                                              if (favoritedata!.data![index]
                                                      .hasVariation ==
                                                  "0") ...[
                                                if (favoritedata!.data![index]
                                                            .availableQty ==
                                                        "" ||
                                                    int.parse(favoritedata!
                                                            .data![index]
                                                            .availableQty
                                                            .toString()) <=
                                                        0) ...[
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)),
                                                      height: 3.5.h,
                                                      width: 17.w,
                                                      child: Center(
                                                        child: Text(
                                                          'ADD'.tr,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 9.5.sp,
                                                              color:
                                                                  color.green),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              ] else if (favoritedata!
                                                      .data![index].isCart ==
                                                  "0") ...[
                                                InkWell(
                                                  onTap: () async {
                                                    if (favoritedata!
                                                                .data![index]
                                                                .hasVariation ==
                                                            "1" ||
                                                        favoritedata!
                                                            .data![index]
                                                            .addons!
                                                            .isNotEmpty) {
                                                      cart = await Get.to(() =>
                                                          showvariation(
                                                              favoritedata!
                                                                      .data![
                                                                  index]));

                                                      if (cart == 1) {
                                                        _scaffoldKey
                                                            .currentContext
                                                            .reactive;
                                                        // print(favoritedata!
                                                        //     .data![index]
                                                        //     .itemQty);
                                                        setState(() {
                                                          favoritedata!
                                                              .data![index]
                                                              .isCart = "1";

                                                          favoritedata!
                                                              .data![index]
                                                              .itemQty = int.parse(
                                                                  favoritedata!
                                                                      .data![
                                                                          index]
                                                                      .itemQty
                                                                      .toString()) +
                                                              1;
                                                        });
                                                        print(favoritedata!
                                                            .data![index]
                                                            .itemQty);
                                                      }
                                                    } else {
                                                      addtocart(index);
                                                    }
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)),
                                                      height: 3.5.h,
                                                      width: 17.w,
                                                      child: Center(
                                                        child: Text(
                                                          'ADD'.tr,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 9.5.sp,
                                                              color:
                                                                  color.black),
                                                        ),
                                                      )),
                                                ),
                                              ] else if (favoritedata!
                                                      .data![index].isCart ==
                                                  "1") ...[
                                                Container(
                                                  height: 3.6.h,
                                                  width: 22.w,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    // color: Theme.of(context).accentColor
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            loader
                                                                .showErroDialog(
                                                              description:
                                                                  LocaleKeys
                                                                          .The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item
                                                                      .tr,
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: color.green,
                                                            size: 16,
                                                          )),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                        ),
                                                        child: Text(
                                                          favoritedata!
                                                              .data![index]
                                                              .itemQty!
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 10.sp),
                                                        ),
                                                      ),
                                                      InkWell(
                                                          onTap: () async {
                                                            if (favoritedata!
                                                                        .data![
                                                                            index]
                                                                        .hasVariation ==
                                                                    "1" ||
                                                                // ignore: prefer_is_empty
                                                                favoritedata!
                                                                        .data![
                                                                            index]
                                                                        .addons!
                                                                        .length >
                                                                    0) {
                                                              cart = await Get.to(() =>
                                                                  showvariation(
                                                                      favoritedata!
                                                                              .data![
                                                                          index]));
                                                              if (cart == 1) {
                                                                setState(() {
                                                                  favoritedata!
                                                                      .data![
                                                                          index]
                                                                      .itemQty = int.parse(favoritedata!
                                                                          .data![
                                                                              index]
                                                                          .itemQty
                                                                          .toString()) +
                                                                      1;
                                                                });
                                                              }
                                                            } else {
                                                              addtocart(index);
                                                            }
                                                          },
                                                          child: Icon(
                                                            Icons.add,
                                                            color: color.green,
                                                            size: 16,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ));
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: color.primarycolor,
                  ),
                );
              },
            )));
  }
}
