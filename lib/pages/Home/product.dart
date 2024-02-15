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
      if(userid == "" || userid == null){
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
      }else{
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

      if(userid == "" || userid == null){
        map = {
          "session_id": sessionid ?? "",
          "item_id": widget.itemid,
        };
      }else{
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

  add_to_cartAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double addonstotalprice = 0;
    for (int i = 0; i < arr_addonsprice.length; i++) {
      addonstotalprice = addonstotalprice + double.parse(arr_addonsprice[i]);
    }
    try {
      var map;
      loader.showLoading();
      if(userid == "" || userid == null){
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
      }else{
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
       List<bool> selectedSize = [false, false, true, false, false];
  List<bool> selectedColor = [true, false, true, false];


final pageContent = [
    "assets/images/products/shirt-1.png",
    "Roller Rabbit",
    "Vado Odelle Dress",
    "\$129.99",
    "Experience the grace of nature .",
    "Get a little lift from these Sam Edelman sandals featuring ruched straps and leather lace-up ties, while a braided jute sole makes a fresh statement for summer.",
    "320"
  ];

      var sizeToggleButton = SizedBox(
      width: width(context) * 0.9,
      child: ToggleButtons(
        renderBorder: false,
        color: MyColors.subtitleColor,
        selectedColor: MyColors.forgroundWhiteColor,
        fillColor: Colors.transparent,
        splashColor: Colors.transparent,
        isSelected: selectedSize,
        onPressed: (index) {
          setState(() {
            selectedSize[index] = true;
            for (int i = 0; i < selectedSize.length; i++) {
              if (i != index) {
                selectedSize[i] = false;
              }
            }
          });
        },
        children: [
          Container(
              decoration: BoxDecoration(
                color: selectedSize[0]
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: MyColors.forgroundWhiteColor, width: 1),
              ),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: const Text(
                "S",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
          Container(
              decoration: BoxDecoration(
                color: selectedSize[1]
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: MyColors.forgroundWhiteColor, width: 1),
              ),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: const Text(
                "M",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
          Container(
              decoration: BoxDecoration(
                color: selectedSize[2]
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: MyColors.forgroundWhiteColor, width: 1),
              ),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: const Text(
                "L",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
          Container(
              decoration: BoxDecoration(
                color: selectedSize[3]
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: MyColors.forgroundWhiteColor, width: 1),
              ),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: const Text(
                "XL",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
          Container(
              decoration: BoxDecoration(
                color: selectedSize[4]
                    ? MyColors.primaryColor
                    : MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: MyColors.forgroundWhiteColor, width: 1),
              ),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: const Text(
                "XXL",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );

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
          return Scaffold(

                appBar: AppBar(
                  title: const Text("Product Dispay",
                  style: TextStyle(
                    fontFamily: 'Poppins_semibold'
                  ),),
                  centerTitle: true,

                  actions: [
                    if(is_login == "1") ...[
                    Positioned(
                      right: 3.w,
                      top: 1.h,
                      child: Container(
                        height: 5.5.h,
                        width: 5.5.h,
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height / 80),
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
                              removefavarite(
                                  "favorite", widget.itemid.toString());
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
                    
            
                ),

              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                      

                        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.network(
                                itemdata!.data!.itemImages![0].imageUrl
                                    .toString(),
                                fit: BoxFit.contain,
                              ),
            Container(
              padding: const EdgeInsets.all(padding5),
              decoration: const BoxDecoration(
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
                          children: [
                            SizedBox(
                              height: height(context) * 0.1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemdata!.data!.itemName.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text( itemdata!.data!.categoryInfo!.categoryName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),

                                           if (itemdata!.data!.hasVariation == "1") ...[
                            Text(
                              currency_position == "1"
                                  ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![0].productPrice.toString()))}"
                                  : "${numberFormat.format(double.parse(itemdata!.data!.variation![0].productPrice.toString()))}$currency",
                              style: TextStyle(
                                fontSize: 21.sp,
                                fontFamily: 'Poppins_bold',
                              ),
                            ),
                          ] else ...[
                            Text(
                              currency_position == "1"
                                  ? "$currency${numberFormat.format(double.parse(itemdata!.data!.price.toString()))}"
                                  : "${numberFormat.format(double.parse(itemdata!.data!.price.toString()))}$currency",
                              style: TextStyle(
                                fontSize: 21.sp,
                                fontFamily: 'Poppins_bold',
                              ),
                            ),
                          ],
                        
                                  Text(
                                      itemdata!.data!.preparationTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),

                                          //outof stock 
                        Padding(
                          padding: EdgeInsets.only(
                            left: 4.w,
                            right: 4.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (itemdata!.data!.availableQty == "" ||
                                  int.parse(itemdata!.data!.availableQty
                                          .toString()) <=
                                      0) ...[
                                Text(
                                  'Out_of_Stock'.tr,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8.sp,
                                    color: color.grey,
                                  ),
                                ),
                              ] else if (itemdata!.data!.tax == "" ||
                                  itemdata!.data!.tax == "0") ...[
                                Text(
                                  'Inclusive_of_all_taxes'.tr,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8.sp,
                                    color: color.green,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  "${itemdata!.data!.tax}% ${'additional_tax'.tr}",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8.sp,
                                    color: color.red,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                // CounterWidget(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text("Avialable in stock",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: 11)),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Size",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: sizeToggleButton,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Desctiption",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text( (itemdata!.data!.itemDescription == "" ||
                          itemdata!.data!.itemDescription == null)? " - " : itemdata!.data!.itemDescription,
                          style: Theme.of(context).textTheme.labelSmall),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        title: Text("Total Price",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontSize: 9)),
                       /*subtitle: Text(
                         widget.pageContent[3],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 18),
                        ),*/
                        trailing: ElevatedButton(
                          child: SizedBox(
                            width: width(context) * .35,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage("assets/icons/addtocart.png"),
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
                      )
                    ],
                  ),
                  Positioned(
                    right: 5,
                    top: 70,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: MyColors.secondaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              blurStyle: BlurStyle.normal,
                            )
                          ]),
                      child: ToggleButtons(
                          renderBorder: false,
                          direction: Axis.vertical,
                          isSelected: selectedColor,
                          constraints: BoxConstraints(
                              maxHeight: 30,
                              maxWidth: 20,
                              minHeight: 20,
                              minWidth: 20),
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1, color: MyColors.accentColorDark),
                                color: MyColors.secondaryColor,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 10,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1, color: MyColors.accentColorDark),
                                color: MyColors.primaryColor,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 10,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.greenShade,
                                border: Border.all(
                                    width: 1, color: MyColors.accentColorDark),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 10,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1, color: MyColors.accentColorDark),
                                color: MyColors.yellowColor,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 10,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ])),
        











                    //child: Column(

                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(
                  //           height: MediaQuery.of(context).size.width,
                  //           width: MediaQuery.of(context).size.width,
                  //           // color: Colors.green,
                  //           child: ClipRRect(
                  //             child: Image.network(
                  //               itemdata!.data!.itemImages![0].imageUrl
                  //                   .toString(),
                  //               fit: BoxFit.contain,
                  //             ),
                  //           )),
                  //      //item name
                  //       Row(
                  //         children: [
                  //           Padding(
                  //               padding:
                  //                   EdgeInsets.only(left: 4.w, top: 7.3.h)),
                  //           Expanded(
                  //             child: Text(
                  //               itemdata!.data!.itemName.toString(),
                  //               overflow: TextOverflow.clip,
                  //               style: TextStyle(
                  //                 fontSize: 16.sp,
                  //                 fontFamily: 'Poppins_semibold',
                  //               ),
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       //catogeryname and preparation
                  //       Padding(
                  //         padding: EdgeInsets.only(left: 4.w, right: 4.w),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               itemdata!.data!.categoryInfo!.categoryName,
                  //               style: TextStyle(
                  //                 fontSize: 10.sp,
                  //                 fontFamily: 'Poppins',
                  //                 color: color.green,
                  //               ),
                  //             ),
                  //             Text(
                  //               itemdata!.data!.preparationTime,
                  //               style: TextStyle(
                  //                 fontSize: 10.sp,
                  //                 fontFamily: 'Poppins',
                  //                 color: Colors.grey,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //      //variation
                  //       Row(children: [
                  //         Padding(
                  //             padding: EdgeInsets.only(
                  //           left: 4.w,
                  //         )),
                  //         if (itemdata!.data!.hasVariation == "1") ...[
                  //           Text(
                  //             currency_position == "1"
                  //                 ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![0].productPrice.toString()))}"
                  //                 : "${numberFormat.format(double.parse(itemdata!.data!.variation![0].productPrice.toString()))}$currency",
                  //             style: TextStyle(
                  //               fontSize: 21.sp,
                  //               fontFamily: 'Poppins_bold',
                  //             ),
                  //           ),
                  //         ] else ...[
                  //           Text(
                  //             currency_position == "1"
                  //                 ? "$currency${numberFormat.format(double.parse(itemdata!.data!.price.toString()))}"
                  //                 : "${numberFormat.format(double.parse(itemdata!.data!.price.toString()))}$currency",
                  //             style: TextStyle(
                  //               fontSize: 21.sp,
                  //               fontFamily: 'Poppins_bold',
                  //             ),
                  //           ),
                  //         ],
                  //       ]),
                  //      //outof stock 
                  //       Padding(
                  //         padding: EdgeInsets.only(
                  //           left: 4.w,
                  //           right: 4.w,
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.end,
                  //           children: [
                  //             if (itemdata!.data!.availableQty == "" ||
                  //                 int.parse(itemdata!.data!.availableQty
                  //                         .toString()) <=
                  //                     0) ...[
                  //               Text(
                  //                 'Out_of_Stock'.tr,
                  //                 style: TextStyle(
                  //                   fontFamily: 'Poppins',
                  //                   fontSize: 8.sp,
                  //                   color: color.grey,
                  //                 ),
                  //               ),
                  //             ] else if (itemdata!.data!.tax == "" ||
                  //                 itemdata!.data!.tax == "0") ...[
                  //               Text(
                  //                 'Inclusive_of_all_taxes'.tr,
                  //                 style: TextStyle(
                  //                   fontFamily: 'Poppins',
                  //                   fontSize: 8.sp,
                  //                   color: color.green,
                  //                 ),
                  //               ),
                  //             ] else ...[
                  //               Text(
                  //                 "${itemdata!.data!.tax}% ${'additional_tax'.tr}",
                  //                 style: TextStyle(
                  //                   fontFamily: 'Poppins',
                  //                   fontSize: 8.sp,
                  //                   color: color.red,
                  //                 ),
                  //               ),
                  //             ]
                  //           ],
                  //         ),
                  //       ),
                  //      //Description heading
                  //       Container(
                  //         margin: EdgeInsets.only(
                  //           left: 4.w,
                  //           right: 4.w,
                  //           top: 1.h,
                  //         ),
                  //         child: Text(
                  //           'Description',
                  //           style: TextStyle(
                  //               fontSize: 15.sp,
                  //               fontFamily: 'Poppins_semibold'),
                  //         ),
                  //       ),
                  //       if (itemdata!.data!.itemDescription == "" ||
                  //           itemdata!.data!.itemDescription == null) ...[
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //               left: 4.w, top: 1.h, right: 4.w),
                  //           alignment: Alignment.topLeft,
                  //           child: Text(
                  //             " - ",
                  //             style: TextStyle(
                  //                 fontSize: 10.5.sp, fontFamily: 'Poppins'),
                  //           ),
                  //         ),
                  //       ] else ...[
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //               left: 4.w, top: 1.h, right: 4.w),
                  //           alignment: Alignment.topLeft,
                  //           child: Text(
                  //             itemdata!.data!.itemDescription,
                  //             style: TextStyle(
                  //                 fontSize: 10.5.sp, fontFamily: 'Poppins'),
                  //           ),
                  //         ),
                  //       ],
                  //       // variantion of sizes
                  //       if (itemdata!.data!.hasVariation == "1") ...[
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //               left: 4.w, top: 2.h, bottom: 1.h, right: 4.w),
                  //           child: Text(
                  //             itemdata!.data!.attribute!,
                  //             style: TextStyle(
                  //                 fontFamily: 'Poppins_bold', fontSize: 15.sp),
                  //           ),
                  //         ),
                  //         Container(
                  //           padding: EdgeInsets.all(0),
                  //           height: itemdata!.data!.variation!.length * 6.5.h,
                  //           child: ListView.builder(
                  //             physics: NeverScrollableScrollPhysics(),
                  //             itemCount: itemdata!.data!.variation!.length,
                  //             itemBuilder: (context, index) {
                  //               return Padding(
                  //                 padding: EdgeInsets.only(
                  //                     left: 5.w, bottom: 1.h, right: 5.w),
                  //                 child: InkWell(
                  //                   onTap: () {
                  //                     select._variationselecationindex(index);
                  //                   },
                  //                   child: Row(
                  //                     children: [
                  //                       Obx(
                  //                         () => Container(
                  //                           height: 3.3.h,
                  //                           width: 3.3.h,
                  //                           decoration: BoxDecoration(
                  //                               color:
                  //                                   select._variationselecationindex ==
                  //                                           index
                  //                                       ? color.green
                  //                                       : Colors.transparent,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(50),
                  //                               border: Border.all(
                  //                                   color: color.green)),
                  //                           child: Icon(Icons.done,
                  //                               color:
                  //                                   select._variationselecationindex ==
                  //                                           index
                  //                                       ? Colors.white
                  //                                       : Colors.transparent,
                  //                               size: 13.sp),
                  //                         ),
                  //                       ),
                  //                       SizedBox(
                  //                         width: 4.w,
                  //                       ),
                  //                       Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           if (itemdata!
                  //                                       .data!
                  //                                       .variation![index]
                  //                                       .availableQty ==
                  //                                   "" ||
                  //                               int.parse(itemdata!
                  //                                       .data!
                  //                                       .variation![index]
                  //                                       .availableQty
                  //                                       .toString()) <=
                  //                                   0) ...[
                  //                             Text(
                  //                               itemdata!
                  //                                   .data!
                  //                                   .variation![index]
                  //                                   .variation!,
                  //                               style: TextStyle(
                  //                                 fontSize: 11.sp,
                  //                                 fontFamily:
                  //                                     'Poppins_semibold',
                  //                                 color: color.grey,
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               currency_position == "1"
                  //                                   ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))} ${'Out_of_Stock'.tr}"
                  //                                   : "${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}$currency ${'Out_of_Stock'.tr}",
                  //                               style: TextStyle(
                  //                                 fontSize: 8.sp,
                  //                                 fontFamily: 'Poppins',
                  //                                 color: color.grey,
                  //                               ),
                  //                             )
                  //                           ] else ...[
                  //                             Text(
                  //                               itemdata!
                  //                                   .data!
                  //                                   .variation![index]
                  //                                   .variation!,
                  //                               style: TextStyle(
                  //                                 fontSize: 11.sp,
                  //                                 fontFamily:
                  //                                     'Poppins_semibold',
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               currency_position == "1"
                  //                                   ? "$currency${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}"
                  //                                   : "${numberFormat.format(double.parse(itemdata!.data!.variation![index].productPrice!))}$currency",
                  //                               style: TextStyle(
                  //                                   fontSize: 8.sp,
                  //                                   fontFamily: 'Poppins'),
                  //                             )
                  //                           ]
                  //                         ],
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     //add ons
                  //       if (itemdata!.data!.addons!.isNotEmpty) ...[
                  //         Container(
                  //           alignment: Alignment.topLeft,
                  //           margin: EdgeInsets.only(
                  //               left: 4.w, bottom: 1.h, right: 4.w),
                  //           child: Text(
                  //             'Add_ons'.tr,
                  //             style: TextStyle(
                  //                 fontFamily: 'Poppins_bold', fontSize: 15.sp),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           height: itemdata!.data!.addons!.length * 6.5.h,
                  //           child: ListView.builder(
                  //             physics: NeverScrollableScrollPhysics(),
                  //             itemCount: itemdata!.data!.addons!.length,
                  //             itemBuilder: (context, index) {
                  //               return Padding(
                  //                 padding: EdgeInsets.only(
                  //                     left: 5.w, bottom: 1.h, right: 5.w),
                  //                 child: InkWell(
                  //                   onTap: () {
                  //                     setState(() {
                  //                       var addonobject =
                  //                           itemdata!.data!.addons![index];

                  //                       addonobject.isselected == true
                  //                           ? addonobject.isselected = false
                  //                           : addonobject.isselected = true;

                  //                       itemdata!.data!.addons!.removeAt(index);

                  //                       itemdata!.data!.addons!
                  //                           .insert(index, addonobject);
                  //                     });
                  //                   },
                  //                   child: Row(
                  //                     children: [
                  //                       Container(
                  //                         height: 3.3.h,
                  //                         width: 3.3.h,
                  //                         decoration: BoxDecoration(
                  //                             color: itemdata!
                  //                                         .data!
                  //                                         .addons![index]
                  //                                         .isselected ==
                  //                                     false
                  //                                 ? Colors.transparent
                  //                                 : color.green,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(7),
                  //                             border: Border.all(
                  //                                 color: color.green)),
                  //                         child: Icon(Icons.done,
                  //                             color: itemdata!
                  //                                         .data!
                  //                                         .addons![index]
                  //                                         .isselected ==
                  //                                     false
                  //                                 ? Colors.transparent
                  //                                 : Colors.white,
                  //                             size: 13.sp),
                  //                       ),
                  //                       SizedBox(
                  //                         width: 4.w,
                  //                       ),
                  //                       Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             itemdata!
                  //                                 .data!.addons![index].name!,
                  //                             style: TextStyle(
                  //                               fontSize: 11.sp,
                  //                               fontFamily: 'Poppins_semibold',
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             currency_position == "1"
                  //                                 ? "$currency${numberFormat.format(double.parse(itemdata!.data!.addons![index].price.toString()))}"
                  //                                 : "${numberFormat.format(double.parse(itemdata!.data!.addons![index].price.toString()))}$currency",
                  //                             style: TextStyle(
                  //                                 fontSize: 8.sp,
                  //                                 fontFamily: 'Poppins'),
                  //                           )
                  //                         ],
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //      //related product
                  //       if (itemdata!.relateditems!.isNotEmpty) ...[
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //             left: 4.w,
                  //             right: 4.w,
                  //             bottom: 1.h,
                  //             top: 1.h,
                  //           ),
                  //           child: Text(
                  //             'Related_roducts'.tr,
                  //             style: TextStyle(
                  //                 fontFamily: 'Poppins_semibold',
                  //                 fontSize: 14.5.sp),
                  //           ),
                  //         ),
                  //         Container(
                  //           padding: EdgeInsets.only(left: 2.w, right: 2.w),
                  //           height: 33.h,
                  //           child: ListView.builder(
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount: itemdata!.relateditems!.length,
                  //             itemBuilder: (context, index) => InkWell(
                  //               onTap: () {
                  //                 Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => Product(
                  //                           itemdata!.relateditems![index].id)),
                  //                 );
                  //               },
                  //               child: Container(
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(7),
                  //                       border: Border.all(
                  //                           width: 0.8.sp, color: Colors.grey)),
                  //                   margin: EdgeInsets.only(
                  //                     top: 1.h,
                  //                     left: 1.7.w,
                  //                     right: 1.7.w,
                  //                   ),
                  //                   height: 32,
                  //                   width: 45.w,
                  //                   child: Column(children: [
                  //                     Stack(
                  //                       children: [
                  //                         Container(
                  //                           height: 20.h,
                  //                           width: 46.w,
                  //                           decoration: BoxDecoration(
                  //                               borderRadius: BorderRadius.only(
                  //                                   topLeft: Radius.circular(5),
                  //                                   topRight:
                  //                                       Radius.circular(5))),
                  //                           child: ClipRRect(
                  //                             borderRadius: BorderRadius.only(
                  //                                 topLeft: Radius.circular(5),
                  //                                 topRight: Radius.circular(5)),
                  //                             child: Image.network(
                  //                               itemdata!.relateditems![index]
                  //                                   .imageUrl,
                  //                               fit: BoxFit.contain,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         if (itemdata!.relateditems![index]
                  //                                 .hasVariation ==
                  //                             "0") ...[
                  //                           if (itemdata!.relateditems![index]
                  //                                       .availableQty ==
                  //                                   "" ||
                  //                               int.parse(itemdata!
                  //                                       .relateditems![index]
                  //                                       .availableQty
                  //                                       .toString()) <=
                  //                                   0) ...[
                  //                             Positioned(
                  //                               child: Container(
                  //                                 alignment: Alignment.center,
                  //                                 height: 20.h,
                  //                                 width: 46.w,
                  //                                 color: Colors.black38,
                  //                                 child: Text(
                  //                                   'Out_of_Stock'
                  //                                       .tr,
                  //                                   style: TextStyle(
                  //                                     fontSize: 15.sp,
                  //                                     color: Colors.white,
                  //                                     fontFamily:
                  //                                         'poppins_semibold',
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ]
                  //                         ],
                  //                         Positioned(
                  //                             right: 5.0,
                  //                             top: 5.0,
                  //                             child: InkWell(
                  //                               onTap: () {
                  //                                 if (userid == "") {
                  //                                   Navigator.of(context)
                  //                                       .pushAndRemoveUntil(
                  //                                           MaterialPageRoute(
                  //                                               builder: (c) =>
                  //                                                   Login()),
                  //                                           (r) => false);
                  //                                 } else if (itemdata!
                  //                                         .relateditems![index]
                  //                                         .isFavorite ==
                  //                                     "0") {
                  //                                   removefavarite(
                  //                                       "favorite",
                  //                                       itemdata!
                  //                                           .relateditems![
                  //                                               index]
                  //                                           .id
                  //                                           .toString());
                  //                                 } else {
                  //                                   removefavarite(
                  //                                       "unfavorite",
                  //                                       itemdata!
                  //                                           .relateditems![
                  //                                               index]
                  //                                           .id
                  //                                           .toString());
                  //                                 }
                  //                               },
                  //                               child: Container(
                  //                                   height: 6.h,
                  //                                   width: 12.w,
                  //                                   padding:
                  //                                       EdgeInsets.all(9.sp),
                  //                                   decoration: BoxDecoration(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             12),
                  //                                     color: Colors.black26,
                  //                                   ),
                  //                                   child: itemdata!
                  //                                               .relateditems![
                  //                                                   index]
                  //                                               .isFavorite ==
                  //                                           "0"
                  //                                       ? SvgPicture.asset(
                  //                                           'Assets/Icons/Favorite.svg',
                  //                                           color: Colors.white,
                  //                                         )
                  //                                       : SvgPicture.asset(
                  //                                           'Assets/Icons/Favoritedark.svg',
                  //                                           color: Colors.white,
                  //                                         )),
                  //                             )),
                  //                       ],
                  //                     ),
                  //                     Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Padding(
                  //                           padding: EdgeInsets.only(
                  //                               left: 2.w,
                  //                               right: 2.w,
                  //                               top: 1.h),
                  //                           child: Row(
                  //                             children: [
                  //                               Text(
                  //                                 itemdata!
                  //                                     .relateditems![index]
                  //                                     .categoryInfo!
                  //                                     .categoryName,
                  //                                 style: TextStyle(
                  //                                     fontSize: 8.5.sp,
                  //                                     fontFamily: 'Poppins',
                  //                                     color: color.green,
                  //                                     fontWeight:
                  //                                         FontWeight.w600),
                  //                               ),
                  //                               Spacer(),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.only(
                  //                             left: 2.w,
                  //                             right: 2.w,
                  //                           ),
                  //                           child: Row(
                  //                             children: [
                  //                               Expanded(
                  //                                 child: Text(
                  //                                   itemdata!
                  //                                       .relateditems![index]
                  //                                       .itemName,
                  //                                   overflow:
                  //                                       TextOverflow.ellipsis,
                  //                                   style: TextStyle(
                  //                                       fontSize: 14,
                  //                                       fontFamily: 'Poppins',
                  //                                       fontWeight:
                  //                                           FontWeight.w600),
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.only(
                  //                               left: 2.w,
                  //                               right: 2.w,
                  //                               top: 1.3.h),
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                             children: [
                  //                               if (itemdata!.relateditems![index]
                  //                                   .hasVariation ==
                  //                                   "1") ...[
                  //                                 Text(
                  //                                   currency_position == "1"
                  //                                       ? "$currency${numberFormat.format(double.parse(itemdata!.relateditems![index].variation![0].productPrice.toString()))}"
                  //                                       : "${numberFormat.format(double.parse(itemdata!.relateditems![index].variation![0].productPrice.toString()))}$currency",
                  //                                   style: TextStyle(
                  //                                       fontSize: 13,
                  //                                       fontFamily: 'Poppins_bold',
                  //                                       fontWeight:
                  //                                       FontWeight.w600),
                  //                                 ),
                  //                               ] else ...[
                  //                                 Text(
                  //                                   currency_position == "1"
                  //                                       ? "$currency${numberFormat.format(double.parse(itemdata!.relateditems![index].price.toString()))}"
                  //                                       : "${numberFormat.format(double.parse(itemdata!.relateditems![index].price.toString()))}$currency",
                  //                                   style: TextStyle(
                  //                                       fontSize: 13,
                  //                                       fontFamily: 'Poppins_bold',
                  //                                       fontWeight:
                  //                                       FontWeight.w600),
                  //                                 ),
                  //                               ],
                  //                               if (itemdata!.relateditems![index]
                  //                                   .isCart ==
                  //                                   "0") ...[
                  //                                 InkWell(
                  //                                   onTap: () async {
                  //                                     if (itemdata!
                  //                                         .relateditems![
                  //                                     index]
                  //                                         .hasVariation ==
                  //                                         "1" ||
                  //                                         itemdata!
                  //                                             .relateditems![index]
                  //                                             .addons!
                  //                                             .isNotEmpty) {
                  //                                       cart = await Get.to(() =>
                  //                                           showvariation(itemdata!
                  //                                               .relateditems![
                  //                                           index]));
                  //                                       if (cart == 1) {
                  //                                         setState(() {
                  //                                           itemdata!
                  //                                               .relateditems![
                  //                                           index]
                  //                                               .isCart = "1";
                  //                                           itemdata!
                  //                                               .relateditems![
                  //                                           index]
                  //                                               .itemQty =
                  //                                               int.parse(
                  //                                                 itemdata!
                  //                                                     .relateditems![
                  //                                                 index]
                  //                                                     .itemQty!
                  //                                                     .toString(),
                  //                                               ) +
                  //                                                   1;
                  //                                         });
                  //                                       }
                  //                                     } else {
                  //                                       // if (userid == "") {
                  //                                       //   Navigator.of(context)
                  //                                       //       .pushAndRemoveUntil(
                  //                                       //       MaterialPageRoute(
                  //                                       //           builder: (c) =>
                  //                                       //               Login()),
                  //                                       //           (r) => false);
                  //                                       // } else {
                  //                                         addtocart(
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .id,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .itemName,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .imageName,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .itemType,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .tax,
                  //                                             itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .price);
                  //                                       }
                  //                                     // }
                  //                                   },
                  //                                   child: Container(
                  //                                       decoration: BoxDecoration(
                  //                                           borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(4),
                  //                                           border: Border.all(
                  //                                               color:
                  //                                               Colors.grey)),
                  //                                       height: 3.5.h,
                  //                                       width: 17.w,
                  //                                       child: Center(
                  //                                         child: Text(
                  //                                           'ADD'.tr,
                  //                                           style: TextStyle(
                  //                                               fontFamily:
                  //                                               'Poppins',
                  //                                               fontSize: 9.5.sp,
                  //                                               color: color.green),
                  //                                         ),
                  //                                       )),
                  //                                 ),
                  //                               ] else if (itemdata!
                  //                                   .relateditems![index]
                  //                                   .isCart ==
                  //                                   "1") ...[
                  //                                 Container(
                  //                                   height: 3.6.h,
                  //                                   width: 22.w,
                  //                                   decoration: BoxDecoration(
                  //                                     border: Border.all(
                  //                                         color: Colors.grey),
                  //                                     borderRadius:
                  //                                     BorderRadius.circular(5),
                  //                                   ),
                  //                                   child: Row(
                  //                                     mainAxisAlignment:
                  //                                     MainAxisAlignment
                  //                                         .spaceAround,
                  //                                     children: [
                  //                                       InkWell(
                  //                                           onTap: () {
                  //                                             loader.showErroDialog(
                  //                                               description: LocaleKeys
                  //                                                   .The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item
                  //                                                   .tr,
                  //                                             );
                  //                                           },
                  //                                           child: Icon(
                  //                                             Icons.remove,
                  //                                             color: color.green,
                  //                                             size: 16,
                  //                                           )),
                  //                                       Container(
                  //                                         decoration: BoxDecoration(
                  //                                           borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(3),
                  //                                         ),
                  //                                         child: Text(
                  //                                           itemdata!
                  //                                               .relateditems![
                  //                                           index]
                  //                                               .itemQty!
                  //                                               .toString(),
                  //                                           style: TextStyle(
                  //                                               fontSize: 10.sp),
                  //                                         ),
                  //                                       ),
                  //                                       InkWell(
                  //                                           onTap: () async {
                  //                                             if (itemdata!
                  //                                                 .relateditems![
                  //                                             index]
                  //                                                 .hasVariation ==
                  //                                                 "1" ||
                  //                                                 itemdata!
                  //                                                     .relateditems![
                  //                                                 index]
                  //                                                     .addons!
                  //                                                     .length >
                  //                                                     0) {
                  //                                               cart = await Get.to(
                  //                                                       () => showvariation(
                  //                                                       itemdata!
                  //                                                           .relateditems![
                  //                                                       index]));
                  //                                               if (cart == 1) {
                  //                                                 setState(() {
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .itemQty = int
                  //                                                       .parse(
                  //                                                     itemdata!
                  //                                                         .relateditems![
                  //                                                     index]
                  //                                                         .itemQty!
                  //                                                         .toString(),
                  //                                                   ) +
                  //                                                       1;
                  //                                                 });
                  //                                               }
                  //                                             } else {
                  //                                               addtocart(
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .id,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .itemName,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .imageName,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .itemType,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .tax,
                  //                                                   itemdata!
                  //                                                       .relateditems![
                  //                                                   index]
                  //                                                       .price);
                  //                                             }
                  //                                           },
                  //                                           child: Icon(
                  //                                             Icons.add,
                  //                                             color: color.green,
                  //                                             size: 16,
                  //                                           )),
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 0.2.h,
                  //                         )
                  //                       ],
                  //                     )
                  //                   ])),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //       SizedBox(
                  //         height: 9.h,
                  //       )
                  //     ],
                  //   ),
                  // ),
              //appbar
                 Positioned(
                    top: 1.h,
                    left: 3.w,
                    child: Container(
                      height: 5.5.h,
                      width: 5.5.h,
                      // margin: EdgeInsets.only(left: 2.5.w, top: 1.5.h),
                      decoration: BoxDecoration(
                        // shape: BoxShape.values,
                        borderRadius: BorderRadius.circular(6),
                        color: color.black,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              //appbar
                  if(is_login == "1") ...[
                    Positioned(
                      right: 3.w,
                      top: 1.h,
                      child: Container(
                        height: 5.5.h,
                        width: 5.5.h,
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height / 80),
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
                              removefavarite(
                                  "favorite", widget.itemid.toString());
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
              ),
              //navigation button Cart
              bottomSheet: Container(
                  color: Colors.white,
                  height: 8.h,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                                if(is_login == "1") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage(2)),
                                  );
                                }else{
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage(1)),
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
                                  for (int i = 0;
                                      i < itemdata!.data!.addons!.length;
                                      i++) {
                                    if (itemdata!.data!.addons![i].isselected ==
                                        true) {
                                      arr_addonsid.add(itemdata!
                                          .data!.addons![i].id
                                          .toString());
                                      arr_addonsname.add(itemdata!
                                          .data!.addons![i].name
                                          .toString());
                                      arr_addonsprice.add(numberFormat.format(
                                          double.parse(itemdata!
                                              .data!.addons![i].price
                                              .toString())));
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
                      ]))
                      );
        
        },
      ),
    );
  }
}
