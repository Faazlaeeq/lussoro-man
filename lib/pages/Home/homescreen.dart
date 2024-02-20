// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names, avoid_print, unused_element

import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:single_ecommerce/pages/authentication/login.dart';
import 'package:single_ecommerce/model/cart/qtyupdatemodel.dart';
import 'package:single_ecommerce/model/favorite/addtocartmodel.dart';
import 'package:single_ecommerce/model/home/homescreenmodel.dart';
import 'package:single_ecommerce/routes/route_manager.dart';
import 'package:single_ecommerce/theme-old/thememodel.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart';
import 'package:single_ecommerce/widgets/Home/new_arrival_card.dart';
import 'package:single_ecommerce/widgets/common_widgets.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:single_ecommerce/common%20class/allformater.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:single_ecommerce/pages/favorite/showvariation.dart';
import 'package:single_ecommerce/pages/Home/Homepage.dart';
import 'package:single_ecommerce/pages/Home/categoriesinfo.dart';
import 'package:single_ecommerce/pages/Home/product.dart';
import 'package:single_ecommerce/widgets/my_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'Categories.dart';
import 'search.dart';
import 'trendingfood.dart';
import 'package:get/get.dart' hide Trans;

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
  }

  String username = "";
  String userid = "";
  String? is_login;
  String session_id = "";
  String? currency;
  String? currency_position;
  String? profileimage;
  cartcount count = Get.put(cartcount());
  int? cart;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  homescreenmodel? homedata;
  addtocartmodel? addtocartdata;

  // Timer? _timer;

  Future homescreenAPI() async {
    // await Future.delayed(Duration(seconds: 3));
    var map;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = (prefs.getString(UD_user_name) ?? "");
    userid = (prefs.getString(UD_user_id) ?? "");
    is_login = prefs.getString(UD_user_is_login_required);
    profileimage = (prefs.getString(UD_user_profileimage) ?? "");
    session_id = (prefs.getString(UD_user_session_id) ?? "");
    print("user" + userid);
    print("session" + session_id);
    try {
      if (userid != "") {
        map = {"user_id": userid};
      } else {
        map = {"session_id": session_id};
      }
      print(map);
      var response = await Dio().post(
        DefaultApi.appUrl + PostAPI.Home,
        data: map,
      );

      var finalist = await response.data;
      print(response);

      homedata = homescreenmodel.fromJson(finalist);
      print(homedata!.appdata!.maintenanceMode);
      if (homedata!.appdata!.maintenanceMode.toString() == "1") {
        dialogbox.showDialog(
          description: LocaleKeys
              .Sorry_for_the_inconvenience_but_we_are_performing_some_maintenanceatthemomentWewillbebackonlineshortly
              .tr,
        );
      }

      prefs.setString(UD_user_id, homedata!.getprofile!.id.toString());
      prefs.setString(UD_user_name, homedata!.getprofile!.name.toString());
      if (session_id == "") {
        prefs.setString(UD_user_session_id, homedata!.session_id.toString());
      }
      prefs.setString(UD_user_mobile, homedata!.getprofile!.mobile.toString());
      prefs.setString(UD_user_email, homedata!.getprofile!.email.toString());
      prefs.setString(
          UD_user_logintype, homedata!.getprofile!.loginType.toString());
      prefs.setString(UD_user_wallet, homedata!.getprofile!.wallet.toString());
      prefs.setString(UD_user_isnotification,
          homedata!.getprofile!.isNotification.toString());
      prefs.setString(UD_user_ismail, homedata!.getprofile!.isMail.toString());
      prefs.setString(
          UD_user_refer_code, homedata!.getprofile!.referralCode.toString());
      prefs.setString(
          UD_user_profileimage, homedata!.getprofile!.profileImage.toString());

      prefs.setString(APPcurrency, homedata!.appdata!.currency.toString());
      prefs.setString(
          APPcurrency_position, homedata!.appdata!.currencyPosition.toString());
      prefs.setString(APPcart_count, homedata!.cartdata!.totalCount.toString());
      prefs.setString(
          min_order_amount, homedata!.appdata!.minOrderAmount.toString());
      prefs.setString(
          max_order_amount, homedata!.appdata!.maxOrderAmount.toString());
      prefs.setString(restaurantlat, homedata!.appdata!.lat.toString());
      prefs.setString(restaurantlang, homedata!.appdata!.lang.toString());
      prefs.setString(Androidlink, homedata!.appdata!.android.toString());
      prefs.setString(Ioslink, homedata!.appdata!.ios.toString());
      prefs.setString(
          deliverycharges, homedata!.appdata!.deliveryCharge.toString());
      prefs.setString(about_us, homedata!.appdata!.aboutContent.toString());
      prefs.setString(
          referral_amount, homedata!.appdata!.referralAmount.toString());
      prefs.setString(App_check_addons, homedata!.checkaddons.toString());
      prefs.setString(
          UD_user_logintype, homedata!.getprofile!.loginType.toString());

      currency = (prefs.getString(APPcurrency) ?? "");
      currency_position = (prefs.getString(APPcurrency_position) ?? "");
      count.cartcountnumber(int.parse(prefs.getString(APPcart_count)!));

      return response;
    } on DioError catch (e) {
      print("Error = ${e.type}");
    }
  }

  addtocart(itemid, itemname, itemimage, itemtype, itemtax, itemprice) async {
    try {
      var map;
      loader.showLoading();
      if (userid == "" || userid == null) {
        map = {
          "session_id": session_id,
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

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Addtocart, data: map);
      addtocartdata = addtocartmodel.fromJson(response.data);
      if (addtocartdata!.status == 1) {
        loader.hideLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(APPcart_count, addtocartdata!.cartCount.toString());

        count.cartcountnumber(int.parse(prefs.getString(APPcart_count)!));
        setState(() {
          // FavoriteAPI();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  managefavarite(var itemid, String isfavorite, index, String type) async {
    try {
      loader.showLoading();
      var map = {"user_id": userid, "item_id": itemid, "type": isfavorite};
      print(map);

      var favoriteresponse = await Dio()
          .post(DefaultApi.appUrl + PostAPI.Managefavorite, data: map);
      print(favoriteresponse);
      var finaldata = QTYupdatemodel.fromJson(favoriteresponse.data);

      if (finaldata.status == 1) {
        loader.hideLoading();
        if (type == "trending") {
          setState(() {
            isfavorite == "favorite"
                ? homedata!.trendingitems![index].isFavorite = "1"
                : homedata!.trendingitems![index].isFavorite = "0";
            homedata!.trendingitems.reactive;
          });
        } else if (type == "todayspecial") {
          setState(() {
            isfavorite == "favorite"
                ? homedata!.todayspecial![index].isFavorite = "1"
                : homedata!.todayspecial![index].isFavorite = "0";

            print(homedata!.todayspecial![index].isFavorite);
            homedata!.todayspecial.reactive;
          });
        } else if (type == "recommendeditems") {
          setState(() {
            isfavorite == "favorite"
                ? homedata!.recommendeditems![index].isFavorite = "1"
                : homedata!.recommendeditems![index].isFavorite = "0";
          });
        }
      } else {
        loader.hideLoading();
        loader.showErroDialog(description: finaldata.message);
      }
    } catch (e) {
      print(e);
    }
  }

  ImageProvider avatar = AssetImage("Assets/images/avatar.png");
  @override
  Widget build(BuildContext context) {
    if (username != "") {
      avatar = NetworkImage(profileimage.toString());
    }
    return Consumer(
      builder: (context, ThemeModel themenofier, child) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: FutureBuilder(
              future: homescreenAPI(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: color.primarycolor,
                    ),
                  );
                }
                if (homedata!.appdata!.maintenanceMode == 1) {
                  return Text("hiiii");
                }
                return Scaffold(
                  // appBar: AppBar(
                  //   leadingWidth: 40,
                  //   automaticallyImplyLeading: false,
                  //   title: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           if (username == "") ...[
                  //             Text(
                  //               'Welcome_to'.tr,
                  //               style: TextStyle(
                  //                   fontFamily: "Poppins", fontSize: 11.sp),
                  //             ),
                  //             Text(
                  //               'ecommerce_User'.tr,
                  //               style: TextStyle(
                  //                   fontFamily: "Poppins_bold",
                  //                   fontSize: 14.sp),
                  //             ),
                  //           ] else ...[
                  //             Text(
                  //               'hello'.tr,
                  //               style: TextStyle(
                  //                   fontFamily: "Poppins", fontSize: 11.sp),
                  //             ),
                  //             Text(
                  //               username,
                  //               style: TextStyle(
                  //                   fontFamily: "Poppins_bold",
                  //                   fontSize: 14.sp),
                  //             ),
                  //           ]
                  //         ],
                  //       ),
                  //       if (username != "") ...[
                  //         SizedBox(
                  //             height: 50,
                  //             width: 50,
                  //             child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(50),
                  //                 child: Image.network(
                  //                   profileimage.toString(),
                  //                   fit: BoxFit.cover,
                  //                 )))
                  //       ]
                  //     ],
                  //   ),
                  // ),
                  appBar: MyAppbar(
                    scaffoldKey: _scaffoldKey,
                    showTrailingIcon: true,
                    padding: padding2,
                    actionIcon: avatar,
                  ),
                  key: _scaffoldKey,
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: padding4),
                          child: Text(
                            'Welcome_to'.tr,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: padding4,
                          ),
                          child: Text("Our Lussore Man",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: MyColors.subtitleColor,
                                      fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: padding3),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search()),
                              );
                            },

                            child: CommonWidgets.searchBarWithIconButton(
                              context: context,
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Search()),
                                )
                              },
                            ),
                            // child: Row(
                            //   children: [
                            //     SizedBox(
                            //       width: 3.w,
                            //     ),
                            //     Icon(
                            //       Icons.search,
                            //       size: 18.sp,
                            //     ),
                            //     SizedBox(
                            //       width: 2.w,
                            //     ),
                            //     Text(
                            //       'Search_Here'.tr,
                            //       style: TextStyle(
                            //           fontSize: 11.sp,
                            //           fontFamily: "Poppins"),
                            //     )
                            //   ],
                            // )
                          ),
                        ),
                        if (homedata!.banners!.topbanners!.isNotEmpty)
                          ...topBannerWidgets,
                        if (homedata!.categories!.isNotEmpty)
                          ...categoryWidgets(context),
                        if (homedata!.trendingitems!.isNotEmpty)
                          ...trendingWidgetList(context),
                        if (homedata!.banners!.bannersection1!.isNotEmpty)
                          ...bannerSectionWidgetList,
                        if (homedata!.todayspecial!.isNotEmpty)
                          ...todaySpecialWidgetList(context),
                        if (homedata!.banners!.bannersection2!.isNotEmpty)
                          ...bannerSection2WidgetList,
                        if (homedata!.recommendeditems!.isNotEmpty)
                          ...recommededItemWidgetList(context),
                        if (homedata!.banners!.bannersection3!.isNotEmpty)
                          ...bannerSection3Widgets,
                        if (homedata!.testimonials!.isNotEmpty)
                          ...testinomialsWidgets(context),
                        if (homedata!.appdata!.isAppBottomImage.toString() ==
                            "1")
                          ...appbottomImageWidgets(context),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> get topBannerWidgets {
    return [
      SizedBox(
        height: 2.h,
      ),
      SizedBox(
          height: 23.h,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homedata!.banners!.topbanners!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                  left: 5.w,
                  right: 2.w,
                ),
                // height: 20.h,
                width: 80.w,
                child: GestureDetector(
                  onTap: () {
                    if (homedata!.banners!.topbanners![index].type == "2") {
                      print(homedata!.banners!.topbanners![index].itemId);
                      Get.to(() => Product(int.parse(homedata!
                          .banners!.topbanners![index].itemId
                          .toString())));
                    } else if (homedata!.banners!.topbanners![index].type ==
                        "1") {
                      Get.to(() => categories_items(
                            homedata!.banners!.topbanners![index].catId,
                            homedata!.banners!.topbanners![index].categoryInfo!
                                .categoryName,
                          ));
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      homedata!.banners!.topbanners![index].image.toString(),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
          )),
      SizedBox(
        height: 2.5.h,
      ),
    ];
  }

  List<Widget> categoryWidgets(BuildContext context) {
    return [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 4.w,
            ),
          ),
          Text(
            'Categories'.tr,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 15.sp,
                ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Categoriespage(homedata!.categories)),
              );
            },
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 2.5.h,
            ),
          )
        ],
      ),
      Container(
        margin: EdgeInsets.only(
          top: 1.5.h,
          // left: 2.w,
          right: 2.w,
        ),
        padding: const EdgeInsets.symmetric(horizontal: padding3),
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homedata!.categories!.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(left: 2.5.w),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => categories_items(
                    homedata!.categories![index].id,
                    homedata!.categories![index].categoryName.toString(),
                  ),
                );
              },
              child: Container(
                height: 170,
                width: width(context) * 0.4,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        homedata!.categories![index].image.toString(),
                      ),
                    )),
                child: Container(
                    height: 30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: MyColors.accentColor),
                    child: Column(children: [
                      Text(
                        homedata!.categories![index].categoryName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ])),
              ),
              // child: SizedBox(
              //   width: 22.5.w,
              //   child: Column(
              //     mainAxisAlignment:
              //         MainAxisAlignment.spaceBetween,
              //     children: [
              //       Container(
              //         margin: EdgeInsets.only(bottom: 1.h),
              //         height: 10.5.h,
              //         child: ClipRRect(
              //           borderRadius:
              //               BorderRadius.circular(50),
              //           child: Image.network(
              //             homedata!.categories![index].image
              //                 .toString(),
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: Text(
              //           homedata!
              //               .categories![index].categoryName
              //               .toString(),
              //           overflow: TextOverflow.ellipsis,
              //           style: TextStyle(
              //             fontFamily: "Poppins_medium",
              //             fontSize: 9.5.sp,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 2.h,
      ),
    ];
  }

  List<Widget> appbottomImageWidgets(BuildContext context) {
    return [
      SizedBox(
        width: double.infinity,
        child: Image.network(
          homedata!.appdata!.appBottomImageUrl.toString(),
          height: MediaQuery.of(context).size.height / 2,
          fit: BoxFit.fill,
        ),
      ),
    ];
  }

  List<Widget> testinomialsWidgets(BuildContext context) {
    return [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.5.h, left: 4.w),
          ),
          Text(
            'Testimonials'.tr,
            style: TextStyle(fontFamily: "Poppins_bold", fontSize: 15.sp),
          ),
        ],
      ),
      Container(
          margin: EdgeInsets.only(
            top: 2.h,
            // bottom: 20,
            left: 4.w,
            right: 4.w,
          ),
          padding: EdgeInsets.only(
            top: 3.h,
            bottom: 1.5.h,
            left: 2.5.w,
            right: 2.5.w,
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.black,
          ),
          child: CarouselSlider.builder(
              itemCount: homedata!.testimonials!.length,
              itemBuilder: (context, index, realIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(homedata!
                          .testimonials![index].profileImage
                          .toString()),
                    ),
                    SizedBox(
                      height: 0.8.h,
                    ),
                    Text(homedata!.testimonials![index].name.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "Poppins")),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    if (homedata!.testimonials![index].ratting == "1") ...[
                      SizedBox(
                        child: Image.asset(
                          "Assets/Image/ratting1.png",
                          color: Colors.white,
                          width: 25.w,
                        ),
                      )
                    ] else if (homedata!.testimonials![index].ratting ==
                        "2") ...[
                      Image.asset(
                        "Assets/Image/ratting2.png",
                        color: Colors.white,
                        width: 25.w,
                      )
                    ] else if (homedata!.testimonials![index].ratting ==
                        "3") ...[
                      Image.asset(
                        "Assets/Image/ratting3.png",
                        color: Colors.white,
                        width: 25.w,
                      )
                    ] else if (homedata!.testimonials![index].ratting ==
                        "4") ...[
                      Image.asset(
                        "Assets/Image/ratting4.png",
                        color: Colors.white,
                        width: 25.w,
                      )
                    ] else if (homedata!.testimonials![index].ratting ==
                        "5") ...[
                      Image.asset(
                        "Assets/Image/ratting5.png",
                        color: Colors.white,
                        width: 25.w,
                      )
                    ],
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Text(
                      "${homedata!.testimonials![index].ratting.toString()} / 5.0 Reviews",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontFamily: "Poppins"),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Text(
                      homedata!.testimonials![index].comment.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: "Poppins"),
                    ),
                  ],
                );
              },
              options: CarouselOptions(
                enableInfiniteScroll: true,
                disableCenter: true,
                viewportFraction: 1,
              ))),
      SizedBox(height: 3.h),
    ];
  }

  List<Widget> get bannerSection3Widgets {
    return [
      Container(
        margin: EdgeInsets.only(bottom: 2.h),
        height: 13.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homedata!.banners!.bannersection3!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (homedata!.banners!.bannersection3![index].type == "2") {
                  print(homedata!.banners!.bannersection3![index].itemId);
                  Get.to(() => Product(int.parse(
                      homedata!.banners!.bannersection3![index].itemId)));
                } else if (homedata!.banners!.bannersection3![index].type ==
                    "1") {
                  Get.to(() => categories_items(
                        homedata!.banners!.bannersection3![index].catId,
                        homedata!.banners!.bannersection3![index].categoryInfo!
                            .categoryName,
                      ));
                }
              },
              child: Container(
                  padding: EdgeInsets.only(
                    left: 2.w,
                    right: 2.w,
                  ),
                  width: 100.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      homedata!.banners!.bannersection3![index].image
                          .toString(),
                      fit: BoxFit.fill,
                    ),
                  )),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> recommededItemWidgetList(BuildContext context) {
    return [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 4.w,
              top: 2.h,
            ),
          ),
          Text(
            'Recommended'.tr,
            style: TextStyle(fontFamily: "Poppins_bold", fontSize: 15.sp),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Trendingfood(
                          "3",
                          'Recommended'.tr,
                        )),
              );
            },
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 2.5.h,
            ),
          )
        ],
      ),
      SizedBox(
        height: 250,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 3.w,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: homedata!.recommendeditems!.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(RoutesManager.productDisplay,
                      arguments: homedata!.recommendeditems![index].id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: productCard(
                    context,
                    homedata!.recommendeditems![index].imageUrl.toString(),
                    homedata!.recommendeditems![index].itemName.toString(),
                    homedata!
                        .recommendeditems![index].categoryInfo!.categoryName
                        .toString(),
                    homedata!.recommendeditems![index].price.toString(),
                    () {
                      if (userid == "") {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (c) => Login()),
                            (r) => false);
                      } else if (homedata!
                              .recommendeditems![index].isFavorite ==
                          "0") {
                        managefavarite(homedata!.recommendeditems![index].id,
                            "favorite", index, "recommended");
                      } else if (homedata!
                              .recommendeditems![index].isFavorite ==
                          "1") {
                        managefavarite(homedata!.recommendeditems![index].id,
                            "unfavorite", index, "recommended");
                      }
                    },
                  ),
                ));
          },
        ),
      ),
      // SizedBox(
      //   height: 33.h,
      //   child: ListView.builder(
      //     padding: EdgeInsets.only(
      //       right: 3.w,
      //     ),
      //     scrollDirection: Axis.horizontal,
      //     itemCount: homedata!.recommendeditems!.length,
      //     itemBuilder: (context, index) => GestureDetector(
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) =>
      //                   Product(homedata!.recommendeditems![index].id)),
      //         );
      //       },
      //       child: Container(
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(7),
      //               border: Border.all(width: 0.8.sp, color: Colors.grey)),
      //           margin: EdgeInsets.only(
      //             top: 1.h,
      //             left: 3.5.w,
      //           ),
      //           height: 32.h,
      //           width: 45.w,
      //           child: Column(children: [
      //             Stack(
      //               children: [
      //                 Container(
      //                   height: 20.h,
      //                   width: 46.w,
      //                   decoration: BoxDecoration(
      //                       borderRadius: const BorderRadius.only(
      //                           topLeft: Radius.circular(5),
      //                           topRight: Radius.circular(5))),
      //                   child: ClipRRect(
      //                     borderRadius: const BorderRadius.only(
      //                         topLeft: Radius.circular(5),
      //                         topRight: Radius.circular(5)),
      //                     child: Image.network(
      //                       homedata!.recommendeditems![index].imageUrl
      //                           .toString(),
      //                       fit: BoxFit.contain,
      //                     ),
      //                   ),
      //                 ),
      //                 if (homedata!.recommendeditems![index].hasVariation ==
      //                     "0") ...[
      //                   if (homedata!.recommendeditems![index].availableQty ==
      //                           "" ||
      //                       int.parse(homedata!
      //                               .recommendeditems![index].availableQty
      //                               .toString()) <=
      //                           0) ...[
      //                     Positioned(
      //                       child: Container(
      //                         alignment: Alignment.center,
      //                         height: 20.h,
      //                         width: 46.w,
      //                         color: Colors.black38,
      //                         child: Text(
      //                           'Out_of_Stock'.tr,
      //                           style: TextStyle(
      //                             fontSize: 15.sp,
      //                             color: Colors.white,
      //                             fontFamily: 'poppins_semibold',
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ]
      //                 ],
      //                 if (is_login == "1") ...[
      //                   Positioned(
      //                       top: 5.0,
      //                       right: 5.0,
      //                       child: GestureDetector(
      //                         onTap: () {
      //                           if (userid == "") {
      //                             Navigator.of(context).pushAndRemoveUntil(
      //                                 MaterialPageRoute(
      //                                     builder: (c) => Login()),
      //                                 (r) => false);
      //                           } else if (homedata!
      //                                   .recommendeditems![index].isFavorite ==
      //                               "0") {
      //                             managefavarite(
      //                                 homedata!.recommendeditems![index].id,
      //                                 "favorite",
      //                                 index,
      //                                 "todayspecial");
      //                           } else if (homedata!
      //                                   .recommendeditems![index].isFavorite ==
      //                               "1") {
      //                             managefavarite(
      //                                 homedata!.recommendeditems![index].id,
      //                                 "unfavorite",
      //                                 index,
      //                                 "recommendeditems");
      //                           }
      //                         },
      //                         child: Container(
      //                             height: 6.h,
      //                             width: 12.w,
      //                             decoration: BoxDecoration(
      //                               borderRadius: BorderRadius.circular(12),
      //                               color: Colors.black26,
      //                             ),
      //                             child: Center(
      //                               child: homedata!.recommendeditems![index]
      //                                           .isFavorite ==
      //                                       "0"
      //                                   ? SvgPicture.asset(
      //                                       'Assets/Icons/Favorite.svg',
      //                                       color: Colors.white,
      //                                     )
      //                                   : SvgPicture.asset(
      //                                       'Assets/Icons/Favoritedark.svg',
      //                                       color: Colors.white,
      //                                     ),
      //                             )),
      //                       )),
      //                 ]
      //               ],
      //             ),
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.only(
      //                     left: 2.w,
      //                     right: 2.w,
      //                     top: 0.9.h,
      //                   ),
      //                   child: Row(
      //                     children: [
      //                       Expanded(
      //                         child: Text(
      //                           homedata!.recommendeditems![index].categoryInfo!
      //                               .categoryName
      //                               .toString(),
      //                           overflow: TextOverflow.ellipsis,
      //                           style: TextStyle(
      //                             fontSize: 8.sp,
      //                             fontFamily: 'Poppins',
      //                             color: color.green,
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: EdgeInsets.only(
      //                     left: 2.w,
      //                     right: 2.w,
      //                     top: 0.5.h,
      //                   ),
      //                   child: Row(
      //                     children: [
      //                       Expanded(
      //                         child: Text(
      //                           homedata!.recommendeditems![index].itemName
      //                               .toString(),
      //                           overflow: TextOverflow.ellipsis,
      //                           style: TextStyle(
      //                             fontSize: 10.sp,
      //                             fontFamily: 'Poppins_semibold',
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding:
      //                       EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       if (homedata!
      //                               .recommendeditems![index].hasVariation ==
      //                           "1") ...[
      //                         Expanded(
      //                           child: Text(
      //                             currency_position == "1"
      //                                 ? "$currency${numberFormat.format(double.parse(homedata!.recommendeditems![index].variation![0].productPrice.toString()))}"
      //                                 : "${numberFormat.format(double.parse(homedata!.recommendeditems![index].variation![0].productPrice.toString()))}$currency",
      //                             overflow: TextOverflow.ellipsis,
      //                             maxLines: 1,
      //                             style: TextStyle(
      //                               fontSize: 10.sp,
      //                               fontFamily: 'Poppins_bold',
      //                             ),
      //                           ),
      //                         ),
      //                       ] else ...[
      //                         Expanded(
      //                           child: Text(
      //                             currency_position == "1"
      //                                 ? "$currency${numberFormat.format(double.parse(homedata!.recommendeditems![index].price.toString()))}"
      //                                 : "${numberFormat.format(double.parse(homedata!.recommendeditems![index].price.toString()))}$currency",
      //                             overflow: TextOverflow.ellipsis,
      //                             maxLines: 1,
      //                             style: TextStyle(
      //                               fontSize: 10.sp,
      //                               fontFamily: 'Poppins_bold',
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                       if (homedata!.recommendeditems![index].isCart ==
      //                           "0") ...[
      //                         GestureDetector(
      //                           onTap: () async {
      //                             if (homedata!.recommendeditems![index]
      //                                         .hasVariation ==
      //                                     "1" ||
      //                                 homedata!.recommendeditems![index].addons!
      //                                     .isNotEmpty) {
      //                               cart = await Get.to(() => showvariation(
      //                                   homedata!.recommendeditems![index]));
      //                               if (cart == 1) {
      //                                 setState(() {
      //                                   homedata!.recommendeditems![index]
      //                                       .isCart = "1";
      //                                   homedata!.recommendeditems![index]
      //                                       .itemQty = int.parse(homedata!
      //                                           .recommendeditems![index]
      //                                           .itemQty!
      //                                           .toString()) +
      //                                       1;
      //                                 });
      //                               }
      //                             } else {
      //                               // if (userid == "") {
      //                               //   Navigator.of(
      //                               //           context)
      //                               //       .pushAndRemoveUntil(
      //                               //           MaterialPageRoute(
      //                               //               builder: (c) =>
      //                               //                   Login()),
      //                               //           (r) =>
      //                               //               false);
      //                               // } else {
      //                               addtocart(
      //                                   homedata!.recommendeditems![index].id,
      //                                   homedata!
      //                                       .recommendeditems![index].itemName,
      //                                   homedata!
      //                                       .recommendeditems![index].imageName,
      //                                   homedata!
      //                                       .recommendeditems![index].itemType,
      //                                   homedata!.recommendeditems![index].tax,
      //                                   homedata!
      //                                       .recommendeditems![index].price);
      //                             }
      //                             // }
      //                           },
      //                           child: Container(
      //                               decoration: BoxDecoration(
      //                                   borderRadius: BorderRadius.circular(4),
      //                                   border: Border.all(color: Colors.grey)),
      //                               height: 3.5.h,
      //                               width: 17.w,
      //                               child: Center(
      //                                 child: Text(
      //                                   'ADD'.tr,
      //                                   style: TextStyle(
      //                                       fontFamily: 'Poppins',
      //                                       fontSize: 9.5.sp,
      //                                       color: color.green),
      //                                 ),
      //                               )),
      //                         ),
      //                       ] else if (homedata!
      //                               .recommendeditems![index].isCart ==
      //                           "1") ...[
      //                         Container(
      //                           height: 3.6.h,
      //                           width: 22.w,
      //                           decoration: BoxDecoration(
      //                             border: Border.all(color: Colors.grey),
      //                             borderRadius: BorderRadius.circular(5),
      //                           ),
      //                           child: Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceAround,
      //                             children: [
      //                               GestureDetector(
      //                                   onTap: () {
      //                                     loader.showErroDialog(
      //                                       description:
      //                                           'The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item'
      //                                               .tr,
      //                                     );
      //                                   },
      //                                   child: Icon(
      //                                     Icons.remove,
      //                                     color: color.green,
      //                                     size: 16,
      //                                   )),
      //                               Container(
      //                                 decoration: BoxDecoration(
      //                                   borderRadius: BorderRadius.circular(3),
      //                                 ),
      //                                 child: Text(
      //                                   homedata!
      //                                       .recommendeditems![index].itemQty!
      //                                       .toString(),
      //                                   style: TextStyle(fontSize: 10.sp),
      //                                 ),
      //                               ),
      //                               GestureDetector(
      //                                   onTap: () async {
      //                                     if (homedata!.recommendeditems![index]
      //                                                 .hasVariation ==
      //                                             "1" ||
      //                                         homedata!.recommendeditems![index]
      //                                                 .addons!.length >
      //                                             0) {
      //                                       cart = await Get.to(() =>
      //                                           showvariation(homedata!
      //                                               .recommendeditems![index]));
      //                                       if (cart == 1) {
      //                                         setState(() {
      //                                           homedata!
      //                                               .recommendeditems![index]
      //                                               .itemQty = int.parse(
      //                                                   homedata!
      //                                                       .recommendeditems![
      //                                                           index]
      //                                                       .itemQty!
      //                                                       .toString()) +
      //                                               1;
      //                                         });
      //                                       }
      //                                     } else {
      //                                       addtocart(
      //                                           homedata!
      //                                               .recommendeditems![index]
      //                                               .id,
      //                                           homedata!
      //                                               .recommendeditems![index]
      //                                               .itemName,
      //                                           homedata!
      //                                               .recommendeditems![index]
      //                                               .imageName,
      //                                           homedata!
      //                                               .recommendeditems![index]
      //                                               .itemType,
      //                                           homedata!
      //                                               .recommendeditems![index]
      //                                               .tax,
      //                                           homedata!
      //                                               .recommendeditems![index]
      //                                               .price);
      //                                     }
      //                                   },
      //                                   child: Icon(
      //                                     Icons.add,
      //                                     color: color.green,
      //                                     size: 16,
      //                                   )),
      //                             ],
      //                           ),
      //                         ),
      //                       ],
      //                     ],
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   height: 0.2.h,
      //                 )
      //               ],
      //             )
      //           ])),
      //     ),
      //   ),
      // ),

      SizedBox(
        height: 2.5.h,
      ),
    ];
  }

  List<Widget> get bannerSection2WidgetList {
    return [
      SizedBox(
        height: 25.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homedata!.banners!.bannersection2!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (homedata!.banners!.bannersection2![index].type == "2") {
                  print(homedata!.banners!.bannersection2![index].itemId);
                  Get.to(() => Product(int.parse(
                      homedata!.banners!.bannersection2![index].itemId)));
                } else if (homedata!.banners!.bannersection2![index].type ==
                    "1") {
                  Get.to(() => categories_items(
                        homedata!.banners!.bannersection2![index].catId,
                        homedata!.banners!.bannersection2![index].categoryInfo!
                            .categoryName,
                      ));
                }
              },
              child: Container(
                  padding: EdgeInsets.only(
                    left: 2.w,
                    right: 2.w,
                  ),
                  width: 60.w,
                  height: 60.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      homedata!.banners!.bannersection2![index].image
                          .toString(),
                      fit: BoxFit.fill,
                    ),
                  )),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> todaySpecialWidgetList(BuildContext context) {
    return [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 4.w,
              top: 2.h,
            ),
          ),
          Text(
            'Todays_special'.tr,
            style: TextStyle(fontFamily: "Poppins_bold", fontSize: 15.sp),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Trendingfood(
                    "1",
                    'Todays_special'.tr,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 2.5.h,
            ),
          )
        ],
      ),
      SizedBox(
        height: 250,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 3.w,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: homedata!.todayspecial!.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(RoutesManager.productDisplay,
                      arguments: homedata!.todayspecial![index].id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: productCard(
                    context,
                    homedata!.todayspecial![index].imageUrl.toString(),
                    homedata!.todayspecial![index].itemName.toString(),
                    homedata!.todayspecial![index].categoryInfo!.categoryName
                        .toString(),
                    homedata!.todayspecial![index].price.toString(),
                    () {
                      if (userid == "") {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (c) => Login()),
                            (r) => false);
                      } else if (homedata!.todayspecial![index].isFavorite ==
                          "0") {
                        managefavarite(homedata!.todayspecial![index].id,
                            "favorite", index, "todayspecial");
                      } else if (homedata!.todayspecial![index].isFavorite ==
                          "1") {
                        managefavarite(homedata!.todayspecial![index].id,
                            "unfavorite", index, "todayspecial");
                      }
                    },
                  ),
                ));
          },
        ),
      ),
      // SizedBox(
      //   // padding: EdgeInsets.only(left: 1.w, right: 4.w),

      //   height: 33.h,
      //   child: ListView.builder(
      //     padding: EdgeInsets.only(
      //       right: 3.w,
      //     ),
      //     scrollDirection: Axis.horizontal,
      //     itemCount: homedata!.todayspecial!.length,
      //     itemBuilder: (context, index) => GestureDetector(
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) =>
      //                   Product(homedata!.todayspecial![index].id)),
      //         );
      //       },
      //       child: Container(
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(7),
      //               border: Border.all(width: 0.8.sp, color: Colors.grey)),
      //           margin: EdgeInsets.only(
      //             top: 1.h,
      //             left: 3.5.w,
      //           ),
      //           height: 32.h,
      //           width: 45.w,
      //           child: Column(children: [
      //             Stack(
      //               children: [
      //                 Container(
      //                   height: 20.h,
      //                   width: 46.w,
      //                   decoration: BoxDecoration(
      //                       borderRadius: const BorderRadius.only(
      //                           topLeft: Radius.circular(5),
      //                           topRight: Radius.circular(5))),
      //                   child: ClipRRect(
      //                     borderRadius: const BorderRadius.only(
      //                         topLeft: Radius.circular(5),
      //                         topRight: Radius.circular(5)),
      //                     child: Image.network(
      //                       homedata!.todayspecial![index].imageUrl.toString(),
      //                       fit: BoxFit.contain,
      //                     ),
      //                   ),
      //                 ),
      //                 if (homedata!.todayspecial![index].hasVariation ==
      //                     "0") ...[
      //                   if (homedata!.todayspecial![index].availableQty == "" ||
      //                       int.parse(homedata!
      //                               .todayspecial![index].availableQty
      //                               .toString()) <=
      //                           0) ...[
      //                     Positioned(
      //                       child: Container(
      //                         alignment: Alignment.center,
      //                         height: 20.h,
      //                         width: 46.w,
      //                         color: Colors.black38,
      //                         child: Text(
      //                           'Out_of_Stock'.tr,
      //                           style: TextStyle(
      //                             fontSize: 15.sp,
      //                             color: Colors.white,
      //                             fontFamily: 'poppins_semibold',
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ],
      //                 if (is_login == "1") ...[
      //                   Positioned(
      //                       top: 5.0,
      //                       right: 5.0,
      //                       child: GestureDetector(
      //                         onTap: () {
      //                           if (userid == "") {
      //                             Navigator.of(context).pushAndRemoveUntil(
      //                                 MaterialPageRoute(
      //                                     builder: (c) => Login()),
      //                                 (r) => false);
      //                           } else if (homedata!
      //                                   .todayspecial![index].isFavorite ==
      //                               "0") {
      //                             managefavarite(
      //                                 homedata!.todayspecial![index].id,
      //                                 "favorite",
      //                                 index,
      //                                 "todayspecial");
      //                           } else if (homedata!
      //                                   .todayspecial![index].isFavorite ==
      //                               "1") {
      //                             managefavarite(
      //                                 homedata!.todayspecial![index].id,
      //                                 "unfavorite",
      //                                 index,
      //                                 "todayspecial");
      //                           }
      //                         },
      //                         child: Container(
      //                             height: 6.h,
      //                             width: 12.w,
      //                             decoration: BoxDecoration(
      //                               borderRadius: BorderRadius.circular(12),
      //                               color: Colors.black26,
      //                             ),
      //                             child: Center(
      //                               child: homedata!.todayspecial![index]
      //                                           .isFavorite ==
      //                                       "0"
      //                                   ? SvgPicture.asset(
      //                                       'Assets/Icons/Favorite.svg',
      //                                       color: Colors.white,
      //                                     )
      //                                   : SvgPicture.asset(
      //                                       'Assets/Icons/Favoritedark.svg',
      //                                       color: Colors.white,
      //                                     ),
      //                             )),
      //                       )),
      //                 ]
      //               ],
      //             ),
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.only(
      //                     left: 2.w,
      //                     right: 2.w,
      //                     top: 0.9.h,
      //                   ),
      //                   child: Row(
      //                     children: [
      //                       Text(
      //                         homedata!.todayspecial![index].categoryInfo!
      //                             .categoryName
      //                             .toString(),
      //                         style: TextStyle(
      //                           fontSize: 8.sp,
      //                           fontFamily: 'Poppins',
      //                           color: color.green,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: EdgeInsets.only(
      //                     left: 2.w,
      //                     right: 2.w,
      //                     top: 0.5.h,
      //                   ),
      //                   child: Row(
      //                     children: [
      //                       Expanded(
      //                         child: Text(
      //                           homedata!.todayspecial![index].itemName
      //                               .toString(),
      //                           overflow: TextOverflow.ellipsis,
      //                           style: TextStyle(
      //                             fontSize: 10.sp,
      //                             fontFamily: 'Poppins_semibold',
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding:
      //                       EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       if (homedata!.todayspecial![index].hasVariation ==
      //                           "1") ...[
      //                         SizedBox(
      //                           height: 3.h,
      //                           width: 18.w,
      //                           child: Text(
      //                             currency_position == "1"
      //                                 ? "$currency${numberFormat.format(double.parse(homedata!.todayspecial![index].variation![0].productPrice.toString()))}"
      //                                 : "${numberFormat.format(double.parse(homedata!.todayspecial![index].variation![0].productPrice.toString()))}$currency",
      //                             style: TextStyle(
      //                               fontSize: 10.sp,
      //                               fontFamily: 'Poppins_bold',
      //                             ),
      //                             overflow: TextOverflow.ellipsis,
      //                             maxLines: 1,
      //                           ),
      //                         ),
      //                       ] else ...[
      //                         SizedBox(
      //                           height: 3.h,
      //                           width: 18.w,
      //                           child: Text(
      //                             currency_position == "1"
      //                                 ? "$currency${numberFormat.format(double.parse(homedata!.todayspecial![index].price.toString()))}"
      //                                 : "${numberFormat.format(double.parse(homedata!.todayspecial![index].price.toString()))}$currency",
      //                             style: TextStyle(
      //                               fontSize: 10.sp,
      //                               fontFamily: 'Poppins_bold',
      //                             ),
      //                             overflow: TextOverflow.ellipsis,
      //                             maxLines: 1,
      //                           ),
      //                         ),
      //                       ],
      //                       if (homedata!.todayspecial![index].isCart ==
      //                           "0") ...[
      //                         GestureDetector(
      //                           onTap: () async {
      //                             if (homedata!.todayspecial![index]
      //                                         .hasVariation ==
      //                                     "1" ||
      //                                 homedata!.todayspecial![index].addons!
      //                                     .isNotEmpty) {
      //                               cart = await Get.to(() => showvariation(
      //                                   homedata!.todayspecial![index]));
      //                               if (cart == 1) {
      //                                 setState(() {
      //                                   homedata!.todayspecial![index].isCart =
      //                                       "1";
      //                                   homedata!.todayspecial![index].itemQty =
      //                                       int.parse(homedata!
      //                                               .todayspecial![index]
      //                                               .itemQty!
      //                                               .toString()) +
      //                                           1;
      //                                 });
      //                               }
      //                             } else {
      //                               // if (userid == "") {
      //                               //   Navigator.of(
      //                               //           context)
      //                               //       .pushAndRemoveUntil(
      //                               //           MaterialPageRoute(
      //                               //               builder: (c) =>
      //                               //                   Login()),
      //                               //           (r) =>
      //                               //               false);
      //                               // } else {
      //                               addtocart(
      //                                   homedata!.todayspecial![index].id,
      //                                   homedata!.todayspecial![index].itemName,
      //                                   homedata!
      //                                       .todayspecial![index].imageName,
      //                                   homedata!.todayspecial![index].itemType,
      //                                   homedata!.todayspecial![index].tax,
      //                                   homedata!.todayspecial![index].price);
      //                               // }
      //                             }
      //                           },
      //                           child: Container(
      //                               decoration: BoxDecoration(
      //                                   borderRadius: BorderRadius.circular(4),
      //                                   border: Border.all(color: Colors.grey)),
      //                               height: 3.5.h,
      //                               width: 17.w,
      //                               child: Center(
      //                                 child: Text(
      //                                   'ADD'.tr,
      //                                   style: TextStyle(
      //                                       fontFamily: 'Poppins',
      //                                       fontSize: 9.5.sp,
      //                                       color: color.green),
      //                                 ),
      //                               )),
      //                         ),
      //                       ] else if (homedata!.todayspecial![index].isCart ==
      //                           "1") ...[
      //                         Container(
      //                           height: 3.6.h,
      //                           width: 22.w,
      //                           decoration: BoxDecoration(
      //                             border: Border.all(color: Colors.grey),
      //                             borderRadius: BorderRadius.circular(5),
      //                           ),
      //                           child: Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceAround,
      //                             children: [
      //                               GestureDetector(
      //                                   onTap: () {
      //                                     loader.showErroDialog(
      //                                       description:
      //                                           'The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item'
      //                                               .tr,
      //                                     );
      //                                   },
      //                                   child: Icon(
      //                                     Icons.remove,
      //                                     color: color.green,
      //                                     size: 16,
      //                                   )),
      //                               Container(
      //                                 decoration: BoxDecoration(
      //                                   borderRadius: BorderRadius.circular(3),
      //                                 ),
      //                                 child: Text(
      //                                   homedata!.todayspecial![index].itemQty!
      //                                       .toString(),
      //                                   style: TextStyle(fontSize: 10.sp),
      //                                 ),
      //                               ),
      //                               GestureDetector(
      //                                   onTap: () async {
      //                                     if (homedata!.todayspecial![index]
      //                                                 .hasVariation ==
      //                                             "1" ||
      //                                         homedata!.todayspecial![index]
      //                                                 .addons!.length >
      //                                             0) {
      //                                       cart = await Get.to(() =>
      //                                           showvariation(homedata!
      //                                               .todayspecial![index]));
      //                                       if (cart == 1) {
      //                                         setState(() {
      //                                           homedata!.todayspecial![index]
      //                                               .itemQty = int.parse(
      //                                                   homedata!
      //                                                       .todayspecial![
      //                                                           index]
      //                                                       .itemQty!
      //                                                       .toString()) +
      //                                               1;
      //                                         });
      //                                       }
      //                                     } else {
      //                                       addtocart(
      //                                           homedata!
      //                                               .todayspecial![index].id,
      //                                           homedata!.todayspecial![index]
      //                                               .itemName,
      //                                           homedata!.todayspecial![index]
      //                                               .imageName,
      //                                           homedata!.todayspecial![index]
      //                                               .itemType,
      //                                           homedata!
      //                                               .todayspecial![index].tax,
      //                                           homedata!.todayspecial![index]
      //                                               .price);
      //                                       // addtocart(
      //                                       //     index,
      //                                       //     "trending");
      //                                     }
      //                                   },
      //                                   child: Icon(
      //                                     Icons.add,
      //                                     color: color.green,
      //                                     size: 16,
      //                                   )),
      //                             ],
      //                           ),
      //                         ),
      //                       ],
      //                     ],
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   height: 0.2.h,
      //                 )
      //               ],
      //             )
      //           ])),
      //     ),
      //   ),
      // ),

      SizedBox(
        height: 2.5.h,
      ),
    ];
  }

  List<Widget> get bannerSectionWidgetList {
    return [
      Container(
        margin: EdgeInsets.only(top: 2.h),
        height: 13.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homedata!.banners!.bannersection1!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (homedata!.banners!.bannersection1![index].type == "2") {
                  print(homedata!.banners!.bannersection1![index].itemId);
                  Get.to(() => Product(int.parse(
                      homedata!.banners!.bannersection1![index].itemId)));
                } else if (homedata!.banners!.bannersection1![index].type ==
                    "1") {
                  Get.to(() => categories_items(
                        homedata!.banners!.bannersection1![index].catId,
                        homedata!.banners!.bannersection1![index].categoryInfo!
                            .categoryName,
                      ));
                }
              },
              child: Container(
                  padding: EdgeInsets.only(
                    left: 2.w,
                    right: 2.w,
                  ),
                  width: 100.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      homedata!.banners!.bannersection1![index].image
                          .toString(),
                      fit: BoxFit.fill,
                    ),
                  )),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> trendingWidgetList(BuildContext context) {
    return [
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 4.w,
              top: 2.h,
            ),
          ),
          Text(
            'Trending'.tr,
            style: TextStyle(fontFamily: "Poppins_bold", fontSize: 15.sp),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Trendingfood(
                    "2",
                    'Trending'.tr,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 2.5.h,
            ),
          )
        ],
      ),
      SizedBox(
        height: 250,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 3.w,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: homedata!.trendingitems!.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(RoutesManager.productDisplay,
                      arguments: homedata!.trendingitems![index].id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: productCard(
                    context,
                    homedata!.trendingitems![index].imageUrl.toString(),
                    homedata!.trendingitems![index].itemName.toString(),
                    homedata!.trendingitems![index].categoryInfo!.categoryName
                        .toString(),
                    homedata!.trendingitems![index].price.toString(),
                    () {
                      if (userid == "") {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (c) => Login()),
                            (r) => false);
                      } else if (homedata!.trendingitems![index].isFavorite ==
                          "0") {
                        managefavarite(homedata!.trendingitems![index].id,
                            "favorite", index, "trending");
                      } else if (homedata!.trendingitems![index].isFavorite ==
                          "1") {
                        managefavarite(homedata!.trendingitems![index].id,
                            "unfavorite", index, "trending");
                      }
                    },
                  ),
                ));
          },
        ),
      )
      //   SizedBox(
      //     height: 250,
      //     child: ListView.builder(
      //       padding: EdgeInsets.only(
      //         right: 3.w,
      //       ),
      //       scrollDirection: Axis.horizontal,
      //       itemCount: homedata!.trendingitems!.length,
      //       itemBuilder: (context, index) => GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) =>
      //                     Product(homedata!.trendingitems![index].id)),
      //           );
      //         },
      //         child: Container(
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(7),
      //                 border: Border.all(width: 0.8.sp, color: Colors.grey)),
      //             margin: EdgeInsets.only(
      //               top: 1.h,
      //               left: 3.5.w,
      //             ),
      //             height: 32.h,
      //             width: 45.w,
      //             child: Column(children: [
      //               Stack(
      //                 children: [
      //                   Container(
      //                     height: 20.h,
      //                     width: 46.w,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.only(
      //                         topLeft: Radius.circular(
      //                           5,
      //                         ),
      //                         topRight: Radius.circular(
      //                           5,
      //                         ),
      //                       ),
      //                     ),
      //                     child: ClipRRect(
      //                       borderRadius: const BorderRadius.only(
      //                         topLeft: Radius.circular(
      //                           5,
      //                         ),
      //                         topRight: Radius.circular(
      //                           5,
      //                         ),
      //                       ),
      //                       child: Image.network(
      //                         homedata!.trendingitems![index].imageUrl.toString(),
      //                         fit: BoxFit.contain,
      //                       ),
      //                     ),
      //                   ),
      //                   if (homedata!.trendingitems![index].hasVariation ==
      //                       "0") ...[
      //                     if (homedata!.trendingitems![index].availableQty ==
      //                             "" ||
      //                         int.parse(homedata!
      //                                 .trendingitems![index].availableQty
      //                                 .toString()) <=
      //                             0) ...[
      //                       Positioned(
      //                         child: Container(
      //                           alignment: Alignment.center,
      //                           height: 20.h,
      //                           width: 46.w,
      //                           color: Colors.black38,
      //                           child: Text(
      //                             'Out_of_Stock'.tr,
      //                             style: TextStyle(
      //                               fontSize: 15.sp,
      //                               color: Colors.white,
      //                               fontFamily: 'poppins_semibold',
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ]
      //                   ],
      //                   if (is_login == "1") ...[
      //                     Positioned(
      //                       top: 5.0,
      //                       right: 5.0,
      //                       child: GestureDetector(
      //                         onTap: () {
      //                           if (userid == "") {
      //                             Navigator.of(context).pushAndRemoveUntil(
      //                                 MaterialPageRoute(builder: (c) => Login()),
      //                                 (r) => false);
      //                           } else if (homedata!
      //                                   .trendingitems![index].isFavorite ==
      //                               "0") {
      //                             managefavarite(
      //                                 homedata!.trendingitems![index].id,
      //                                 "favorite",
      //                                 index,
      //                                 "trending");
      //                           } else if (homedata!
      //                                   .trendingitems![index].isFavorite ==
      //                               "1") {
      //                             managefavarite(
      //                                 homedata!.trendingitems![index].id,
      //                                 "unfavorite",
      //                                 index,
      //                                 "trending");
      //                           }
      //                         },
      //                         child: Container(
      //                           height: 6.h,
      //                           width: 12.w,
      //                           decoration: BoxDecoration(
      //                             // shape: BoxShape.values,
      //                             borderRadius: BorderRadius.circular(12),
      //                             color: Colors.black26,
      //                           ),
      //                           child: Center(
      //                             child: homedata!
      //                                         .trendingitems![index].isFavorite ==
      //                                     "0"
      //                                 ? SvgPicture.asset(
      //                                     'Assets/Icons/Favorite.svg',
      //                                     color: Colors.white,
      //                                   )
      //                                 : SvgPicture.asset(
      //                                     'Assets/Icons/Favoritedark.svg',
      //                                     color: Colors.white,
      //                                   ),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ]
      //                 ],
      //               ),
      //               Column(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Padding(
      //                     padding: EdgeInsets.only(
      //                       left: 2.w,
      //                       right: 2.w,
      //                       top: 0.9.h,
      //                     ),
      //                     child: Row(
      //                       children: [
      //                         Text(
      //                           homedata!.trendingitems![index].categoryInfo!
      //                               .categoryName
      //                               .toString(),
      //                           style: TextStyle(
      //                             fontSize: 8.sp,
      //                             fontFamily: 'Poppins',
      //                             color: color.green,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                   Padding(
      //                     padding: EdgeInsets.only(
      //                       left: 2.w,
      //                       right: 2.w,
      //                       top: 0.5.h,
      //                     ),
      //                     child: Row(
      //                       children: [
      //                         Expanded(
      //                           child: Text(
      //                             homedata!.trendingitems![index].itemName
      //                                 .toString(),
      //                             overflow: TextOverflow.ellipsis,
      //                             style: TextStyle(
      //                               fontSize: 10.sp,
      //                               fontFamily: 'Poppins_semibold',
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                   Padding(
      //                     padding:
      //                         EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         if (homedata!.trendingitems![index].hasVariation ==
      //                             "1") ...[
      //                           SizedBox(
      //                             height: 3.h,
      //                             width: 18.w,
      //                             child: Text(
      //                               currency_position == "1"
      //                                   ? "$currency${numberFormat.format(double.parse(homedata!.trendingitems![index].variation![0].productPrice.toString()))}"
      //                                   : "${numberFormat.format(double.parse(homedata!.trendingitems![index].variation![0].productPrice.toString()))}$currency",
      //                               style: TextStyle(
      //                                 fontSize: 10.sp,
      //                                 fontFamily: 'Poppins_bold',
      //                               ),
      //                               overflow: TextOverflow.ellipsis,
      //                               maxLines: 1,
      //                             ),
      //                           ),
      //                         ] else ...[
      //                           SizedBox(
      //                             height: 3.h,
      //                             width: 18.w,
      //                             child: Text(
      //                               currency_position == "1"
      //                                   ? "$currency${numberFormat.format(double.parse(homedata!.trendingitems![index].price.toString()))}"
      //                                   : "${numberFormat.format(double.parse(homedata!.trendingitems![index].price.toString()))}$currency",
      //                               style: TextStyle(
      //                                 fontSize: 10.sp,
      //                                 fontFamily: 'Poppins_bold',
      //                               ),
      //                               overflow: TextOverflow.ellipsis,
      //                               maxLines: 1,
      //                             ),
      //                           ),
      //                         ],
      //                         //////
      //                         if (homedata!.trendingitems![index].isCart ==
      //                             "0") ...[
      //                           GestureDetector(
      //                             onTap: () async {
      //                               if (homedata!.trendingitems![index]
      //                                           .hasVariation ==
      //                                       "1" ||
      //                                   homedata!.trendingitems![index].addons!
      //                                       .isNotEmpty) {
      //                                 cart = await Get.to(() => showvariation(
      //                                     homedata!.trendingitems![index]));
      //                                 if (cart == 1) {
      //                                   setState(() {
      //                                     homedata!.trendingitems![index].isCart =
      //                                         "1";
      //                                     homedata!.trendingitems![index]
      //                                         .itemQty = int.parse(homedata!
      //                                             .trendingitems![index].itemQty!
      //                                             .toString()) +
      //                                         1;
      //                                   });
      //                                 }
      //                               } else {
      //                                 // if (userid == "") {
      //                                 //   Navigator.of(
      //                                 //           context)
      //                                 //       .pushAndRemoveUntil(
      //                                 //           MaterialPageRoute(
      //                                 //               builder: (c) =>
      //                                 //                   Login()),
      //                                 //           (r) =>
      //                                 //               false);
      //                                 // } else {
      //                                 addtocart(
      //                                     homedata!.trendingitems![index].id,
      //                                     homedata!
      //                                         .trendingitems![index].itemName,
      //                                     homedata!
      //                                         .trendingitems![index].imageName,
      //                                     homedata!
      //                                         .trendingitems![index].itemType,
      //                                     homedata!.trendingitems![index].tax,
      //                                     homedata!.trendingitems![index].price);
      //                                 //   }
      //                               }
      //                             },
      //                             child: Container(
      //                                 decoration: BoxDecoration(
      //                                     borderRadius: BorderRadius.circular(4),
      //                                     border: Border.all(color: Colors.grey)),
      //                                 height: 3.5.h,
      //                                 width: 17.w,
      //                                 child: Center(
      //                                   child: Text(
      //                                     'ADD'.tr,
      //                                     style: TextStyle(
      //                                         fontFamily: 'Poppins_medium',
      //                                         fontSize: 9.5.sp,
      //                                         color: color.green),
      //                                   ),
      //                                 )),
      //                           ),
      //                         ] else if (homedata!.trendingitems![index].isCart ==
      //                             "1") ...[
      //                           Container(
      //                             height: 3.6.h,
      //                             width: 22.w,
      //                             decoration: BoxDecoration(
      //                               border: Border.all(color: Colors.grey),
      //                               borderRadius: BorderRadius.circular(5),
      //                             ),
      //                             child: Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceAround,
      //                               children: [
      //                                 GestureDetector(
      //                                     onTap: () {
      //                                       loader.showErroDialog(
      //                                         description:
      //                                             'The_item_has_multtiple_customizations_added_Go_to_cart__to_remove_item'
      //                                                 .tr,
      //                                       );
      //                                     },
      //                                     child: Icon(
      //                                       Icons.remove,
      //                                       color: color.green,
      //                                       size: 16,
      //                                     )),
      //                                 Container(
      //                                   decoration: BoxDecoration(
      //                                     borderRadius: BorderRadius.circular(3),
      //                                   ),
      //                                   child: Text(
      //                                     homedata!.trendingitems![index].itemQty!
      //                                         .toString(),
      //                                     style: TextStyle(fontSize: 10.sp),
      //                                   ),
      //                                 ),
      //                                 InkWell(
      //                                     onTap: () async {
      //                                       if (homedata!.trendingitems![index]
      //                                                   .hasVariation ==
      //                                               "1" ||
      //                                           homedata!.trendingitems![index]
      //                                                   .addons!.length >
      //                                               0) {
      //                                         cart = await Navigator.of(context)
      //                                             .push(MaterialPageRoute(
      //                                           builder: (context) =>
      //                                               showvariation(homedata!
      //                                                   .trendingitems![index]),
      //                                         ));

      //                                         if (cart == 1) {
      //                                           setState(() {
      //                                             homedata!.trendingitems![index]
      //                                                 .itemQty = int.parse(
      //                                                     homedata!
      //                                                         .trendingitems![
      //                                                             index]
      //                                                         .itemQty) +
      //                                                 1;
      //                                           });
      //                                         }
      //                                       } else {
      //                                         addtocart(
      //                                             homedata!
      //                                                 .trendingitems![index].id,
      //                                             homedata!.trendingitems![index]
      //                                                 .itemName,
      //                                             homedata!.trendingitems![index]
      //                                                 .imageName,
      //                                             homedata!.trendingitems![index]
      //                                                 .itemType,
      //                                             homedata!
      //                                                 .trendingitems![index].tax,
      //                                             homedata!.trendingitems![index]
      //                                                 .price);
      //                                       }
      //                                     },
      //                                     child: Icon(
      //                                       Icons.add,
      //                                       color: color.green,
      //                                       size: 16,
      //                                     )),
      //                               ],
      //                             ),
      //                           ),
      //                         ],
      //                       ],
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: 0.2.h,
      //                   )
      //                 ],
      //               )
      //             ])),
      //       ),
      //     ),
      //   ),
      // ];
    ];
  }
}

// final http.Response httpresponse = await http.post(
//   Uri.parse(
//     DefaultApi.appUrl + PostAPI.Home,
//   ),
//   body: map,
//
// homedata = homescreenmodel.fromJson(jsonDecode(httpresponse.body));
// print("object");
