// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:single_ecommerce/model/orders/orderhistory.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:single_ecommerce/common%20class/allformater.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import '../../theme-old/thememodel.dart';
import 'orderdetails.dart';

class Orderhistory extends StatefulWidget {
  const Orderhistory({Key? key}) : super(key: key);

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  int tabvalue = 1;
  orderhistorymodel? Ordersdata;
  String? currency;
  String? currency_position;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = (prefs.getString(APPcurrency) ?? "");
    currency_position = (prefs.getString(APPcurrency_position) ?? "");
  }

  Future _OrderhistoryAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString(UD_user_id).toString();
    try {
      loader.showLoading();
      var map = {"user_id": userid, "type": tabvalue.toString()};
      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Orderhistory, data: map);
      var finalist = await response.data;
      loader.hideLoading();
      Ordersdata = orderhistorymodel.fromJson(finalist);

      return Ordersdata;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themenofier, child) {
      return Scaffold(
        appBar: AppBar(
            leadingWidth: 70,
            toolbarHeight: 14.h,
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(backgroundColor: MyColors.mPrimaryColor),
                          icon: ImageIcon(
                            AssetImage("Assets/Icons/arrow-smooth-left.png"),
                            color: MyColors.secondaryColor,
                            size: 20,
                          ),
                        ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              'My_Orders'.tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins_semibold',
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            tabvalue = 1;
                            Ordersdata!.data!.clear();
                          });
                          _OrderhistoryAPI();
                        },
                        child: SizedBox(
                          height: 7.h,
                          width: 30.w,
                          child: Center(
                            child: Text(
                              'Processing'.tr,
                              style: TextStyle(
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5.sp),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            tabvalue = 2;

                            Ordersdata!.data!.clear();
                          });
                          _OrderhistoryAPI();
                        },
                        child: SizedBox(
                          height: 7.h,
                          width: 30.w,
                          child: Center(
                            child: Text(
                              'Completed'.tr,
                              style: TextStyle(
                                  color: color.darkblack,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5.sp),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            tabvalue = 3;

                            Ordersdata!.data!.clear();
                          });
                          _OrderhistoryAPI();
                        },
                        child: SizedBox(
                          height: 7.h,
                          width: 30.w,
                          child: Center(
                            child: Text(
                              'Cancelled'.tr,
                              style: TextStyle(
                                  color: color.red,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 0.3.h,
                        width: 9.w,
                        color: tabvalue == 1 ? Colors.black : Colors.transparent,
                      ),
                      Container(
                        height: 0.3.h,
                        width: 9.w,
                        color: tabvalue == 2 ? color.black : Colors.transparent,
                      ),
                      Container(
                        height: 0.3.h,
                        width: 9.w,
                        color: tabvalue == 3 ? color.black : Colors.transparent,
                      )
                    ],
                  )
                ],
              ),
            )),
        body: _Processing(),
      );
    });
  }

  _Processing() {
    return FutureBuilder(
        future: _OrderhistoryAPI(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (Ordersdata!.data!.isEmpty) {
              return Center(
                child: Text(
                  'No_data_found'.tr,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.sp,
                      color: Colors.black),
                ),
              );
            }
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: Ordersdata!.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Orderdetails(
                                Ordersdata!.data![index].id.toString())),
                      );
                    },
                    child: Container(
                        margin:
                            EdgeInsets.only(top: 2.h, left: 3.w, right: 3.w),
                        padding: EdgeInsets.all(1.h),
                        width: double.infinity,
                        height: 14.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "#${Ordersdata!.data![index].orderNumber.toString()}",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Poppins_bold'),
                                  ),
                                  Spacer(),
                                  if (Ordersdata!.data![index].status ==
                                      "1") ...[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: color.darkblack,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(11),
                                      height: 4.5.h,
                                      child: Center(
                                        child: Text('Placed'.tr,
                                            style: TextStyle(
                                                fontSize: 9.5.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                    )
                                  ] else if (Ordersdata!.data![index].status ==
                                      "2") ...[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: color.status2,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(7),
                                      height: 4.5.h,
                                      child: Center(
                                        child: Text('Preparing'.tr,
                                            style: TextStyle(
                                                fontSize: 9.5.sp,
                                                fontFamily: 'Poppins',
                                                color: Colors.white)),
                                      ),
                                    )
                                  ] else if (Ordersdata!.data![index].status ==
                                      "3") ...[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: color.status3,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(7),
                                      height: 4.5.h,
                                      child: Center(
                                        child: Text('Ready'.tr,
                                            style: TextStyle(
                                                fontSize: 9.5.sp,
                                                fontFamily: 'Poppins',
                                                color: Colors.white)),
                                      ),
                                    )
                                  ] else if (Ordersdata!.data![index].status ==
                                      "4") ...[
                                    if (Ordersdata!.data![index].orderType ==
                                        "1") ...[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: color.status4,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.all(7),
                                        height: 4.5.h,
                                        child: Center(
                                          child: Text('On_the_way'.tr,
                                              style: TextStyle(
                                                  fontSize: 9.5.sp,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white)),
                                        ),
                                      )
                                    ] else if (Ordersdata!
                                            .data![index].orderType ==
                                        "2") ...[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: color.status4,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.all(7),
                                        height: 4.5.h,
                                        child: Center(
                                          child: Text('Waiting_for_pickup'.tr,
                                              style: TextStyle(
                                                  fontSize: 9.5.sp,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white)),
                                        ),
                                      )
                                    ]
                                  ] else if (Ordersdata!.data![index].status ==
                                      "5") ...[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: color.status5,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(7),
                                      height: 4.5.h,
                                      child: Center(
                                        child: Text('Completed'.tr,
                                            style: TextStyle(
                                                fontSize: 9.5.sp,
                                                fontFamily: 'Poppins',
                                                color: Colors.white)),
                                      ),
                                    )
                                  ] else if (Ordersdata!.data![index].status ==
                                      "6") ...[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: color.status67,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(7),
                                      height: 4.5.h,
                                      child: Center(
                                        child: Text('Cancelled'.tr,
                                            style: TextStyle(
                                                fontSize: 9.5.sp,
                                                fontFamily: 'Poppins',
                                                color: Colors.white)),
                                      ),
                                    )
                                  ] else if (Ordersdata!.data![index].status ==
                                      "7") ...[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: color.status67,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(7),
                                      height: 4.5.h,
                                      child: Center(
                                        child: Text('Cancelled'.tr,
                                            style: TextStyle(
                                                fontSize: 9.5.sp,
                                                fontFamily: 'Poppins',
                                                color: Colors.white)),
                                      ),
                                    )
                                  ]
                                ],
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: 0.3.h, bottom: 0.2.h),
                                height: 0.5.sp,
                                color: Colors.black,
                              ),
                              Row(
                                children: [
                                  Text('Paymenttype'.tr,
                                      style: TextStyle(
                                          fontSize: 8.5.sp,
                                          fontFamily: 'Poppins_semibold',
                                          color: Colors.black)),
                                  if (Ordersdata!
                                          .data![index].transactionType ==
                                      "1") ...[
                                    Text('Cash'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins_semibold',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "2") ...[
                                    Text('Wallet'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins_semibold',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "3") ...[
                                    Text('RazorPay'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "4") ...[
                                    Text('Stripepay'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "5") ...[
                                    Text('Flutterwave'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "6") ...[
                                    Text('Paystack'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "7") ...[
                                    Text('MercadoPago'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "8") ...[
                                    Text('myFatoorah'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "9") ...[
                                    Text('paypal'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].transactionType ==
                                      "10") ...[
                                    Text('ToyyibPay'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ],
                                  Spacer(),
                                  if (Ordersdata!.data![index].orderType ==
                                      "1") ...[
                                    Text('Delivery'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins_semibold',
                                            color: Colors.grey)),
                                  ] else if (Ordersdata!
                                          .data![index].orderType ==
                                      "2") ...[
                                    Text('Take_away'.tr,
                                        style: TextStyle(
                                            fontSize: 8.5.sp,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                  ]
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      FormatedDate(Ordersdata!.data![index].date
                                          .toString()),
                                      style: TextStyle(
                                        fontSize: 10.5.sp,
                                        fontFamily: 'Poppins',
                                      )),
                                  Text(
                                      currency_position == "1"
                                          ? "$currency${numberFormat.format(double.parse(Ordersdata!.data![index].grandTotal))}"
                                          : "${numberFormat.format(double.parse(Ordersdata!.data![index].grandTotal))}$currency",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Poppins_semibold',
                                      )),
                                ],
                              )
                            ])),
                  );
                });
          }
          return Center(
              // child: CircularProgressIndicator(
              //   color: color.red,
              // ),
              );
        });
  }
}
