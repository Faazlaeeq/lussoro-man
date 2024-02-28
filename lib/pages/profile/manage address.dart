// ignore_for_file: unnecessary_null_comparison, file_names, must_be_immutable, camel_case_types, use_key_in_widget_constructors, avoid_print, non_constant_identifier_names, avoid_unnecessary_containers, use_build_context_synchronously, unused_local_variable, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:single_ecommerce/model/cart/qtyupdatemodel.dart';
import 'package:single_ecommerce/model/settings/deleteaddressmodel.dart';
import 'package:single_ecommerce/model/settings/getaddressmodel.dart';
import 'package:single_ecommerce/pages/profile/confirm%20location.dart';
import 'package:single_ecommerce/theme-old/thememodel.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/common%20class/height.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:single_ecommerce/common%20class/engString.dart';
import '../../config/location/location.dart';
import 'addaddress.dart';

enum DataStatus { none, compleated, error }

class Manage_Addresses extends StatefulWidget {
  int? isorder;
  // const Manage_Addresses({Key? key}) : super(key: key);

  @override
  State<Manage_Addresses> createState() => _Manage_AddressesState();
  Manage_Addresses([this.isorder]);
}

class _Manage_AddressesState extends State<Manage_Addresses> {
  String? userid;
  getaddressmodel? addressdata;
  deleteaddressmodel? deleteaddressdata;
  QTYupdatemodel? checkzone;

  @override
  void initState() {
    super.initState();
    getaddressAPI();
  }

  Future getaddressAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(UD_user_id);

    try {
      var map = {"user_id": userid};

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Getaddress, data: map);
      var finallist = response.data;
      addressdata = getaddressmodel.fromJson(finallist);
      return addressdata!.data.toString();
    } catch (e) {
      print(e);
    }
  }

  Deleteaddress(id, index) async {
    try {
      loader.showLoading();
      var map = {"address_id": id};
      print(map);
      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.Deleteaddress, data: map);
      var finalist = await response.data;
      deleteaddressdata = deleteaddressmodel.fromJson(finalist);
      print(index);
      setState(() {
        addressdata!.data!.remove(index);
      });

      loader.hideLoading();

      print(deleteaddressdata);
    } catch (e) {
      rethrow;
    }
  }

  checkdeliveryzoneAPI(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      loader.showLoading();
      var map = {
        "lat": addressdata!.data![index].lat,
        "lang": addressdata!.data![index].lang,
      };
      print(map);
      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.checkdeliveryzone, data: map);
      checkzone = QTYupdatemodel.fromJson(response.data);
      loader.hideLoading();
      if (checkzone!.status == 1) {
        prefs.setString(Delivery_charge, checkzone!.deliveryCharge.toString());
        Navigator.pop(context, addressdata!.data![index]);
      } else {
        loader.showErroDialog(description: checkzone!.message);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themenofier, child) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
                      leading: IconButton(
                  onPressed: () {
                            Navigator.of(context).pop(context);
                          },
                  style: ButtonStyle(backgroundColor: MyColors.mPrimaryColor),
                  icon: ImageIcon(
                    AssetImage("Assets/Icons/arrow-smooth-left.png"),
                    color: MyColors.secondaryColor,
                    size: 20,
                  ),
                ),
              title: Text(
                'Myadresses'.tr,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontFamily: 'Poppins_semibold', fontSize: 12.sp),
              ),
              centerTitle: true,
              leadingWidth: 70,
            ),
            body: FutureBuilder(
              future: getaddressAPI(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (addressdata!.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No_data_found'.tr,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.sp,
                            color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        padding: EdgeInsets.only(bottom: 8.h,top: 2.h),
                        itemCount: addressdata!.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (widget.isorder == 1) {
                                if (DefaultApi.environment == "sendbox") {
                                  Navigator.pop(
                                      context, addressdata!.data![index]);
                                  checkdeliveryzoneAPI(index);
                                } else {
                                  checkdeliveryzoneAPI(index);
                                }
                                // Navigator.pop(context, addressdata!.data![index]);
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 4.w, right: 4.w,top: 1.h),
                                color:Color.fromARGB(255, 248, 248, 248),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        if (addressdata!
                                                .data![index].addressType
                                                .toString() ==
                                            "1") ...[
                                          SvgPicture.asset(
                                            'Assets/Icons/Home.svg',
                                            color: themenofier.isdark
                                                ? Colors.white
                                                : null,
                                          ),
                                        ] else if (addressdata!
                                                .data![index].addressType
                                                .toString() ==
                                            "2") ...[
                                          SvgPicture.asset(
                                            'Assets/svgicon/office.svg',
                                            color: themenofier.isdark
                                                ? Colors.white
                                                : null,
                                          ),
                                        ] else if (addressdata!
                                                .data![index].addressType
                                                .toString() ==
                                            "3") ...[
                                          SvgPicture.asset(
                                            'Assets/svgicon/Address.svg',
                                            color: themenofier.isdark
                                                ? Colors.white
                                                : null,
                                          ),
                                        ],
                                        if (addressdata!
                                                .data![index].addressType
                                                .toString() ==
                                            "1") ...[
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 3.w,
                                              right: 3.w,
                                            ),
                                            child: Text(
                                              'Home'.tr,
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins_semibold',
                                                  fontSize: 12.sp),
                                            ),
                                          ),
                                        ] else if (addressdata!
                                                .data![index].addressType
                                                .toString() ==
                                            "2") ...[
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 3.w,
                                              right: 3.w,
                                            ),
                                            child: Text(
                                              'Office'.tr,
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins_semibold',
                                                  fontSize: 12.sp),
                                            ),
                                          ),
                                        ] else if (addressdata!
                                                .data![index].addressType
                                                .toString() ==
                                            "3") ...[
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 3.w,
                                              right: 3.w,
                                            ),
                                            child: Text(
                                              'Other'.tr,
                                              style: TextStyle(
                                                  fontFamily:
                                                      'Poppins_semibold',
                                                  fontSize: 12.sp),
                                            ),
                                          )
                                        ],
                                        const Spacer(),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text('Alert'),
                                                          content: Text(
                                                            LocaleKeys
                                                                .Are_you_sure_to_delete_this_address
                                                                .tr,
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                'Yes'.tr,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Deleteaddress(
                                                                    addressdata!
                                                                        .data![
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    index);
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                'Cancel'.tr,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });

                                                  print("close");
                                                },
                                                icon: SvgPicture.asset(
                                                  'Assets/svgicon/delete.svg',
                                                  color: themenofier.isdark
                                                      ? Colors.white
                                                      : null,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Get.to(() => Add_address(
                                                        "1",
                                                        addressdata!
                                                            .data![index].id
                                                            .toString(),
                                                        double.parse(
                                                            addressdata!
                                                                .data![index]
                                                                .lat),
                                                        double.parse(
                                                            addressdata!
                                                                .data![index]
                                                                .lang),
                                                        addressdata!
                                                            .data![index].area,
                                                        addressdata!
                                                            .data![index]
                                                            .houseNo,
                                                        addressdata!
                                                            .data![index]
                                                            .address,
                                                        addressdata!
                                                            .data![index]
                                                            .addressType
                                                            .toString(),
                                                      ));
                                                },
                                                icon: SvgPicture.asset(
                                                  'Assets/svgicon/Edit.svg',
                                                  color: themenofier.isdark
                                                      ? Colors.white
                                                      : null,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "${addressdata!.data![index].houseNo.toString()},${addressdata!.data![index].area.toString()},${addressdata!.data![index].address.toString()}",
                                      style: TextStyle(
                                          fontSize: 8.8.sp,
                                          fontFamily: 'Poppins'),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                          top: 3.w,
                                        ),
                                        height: 0.8.sp,
                                        width: double.infinity,
                                        color: Colors.black),
                                  ],
                                )),
                          );
                        });
                  }
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: color.primarycolor,
                  ),
                );
              },
            ),
            bottomSheet: Container(
              margin: EdgeInsets.only(
                bottom: 0.8.h,
                left: 4.w,
                right: 4.w,
              ),
              height: 6.5.h,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // if (Engstring.locationpermission == false) {
                  //   location_permission().parmission();
                  // } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Confirm_location()),
                  ).then((value) => setState(() {}));
                  setState(() {});
                  // }
                },
                style: TextButton.styleFrom(
                  backgroundColor: color.darkblack,
                ),
                child: Text(
                  'Add_New_Address'.tr,
                  style: TextStyle(
                      fontFamily: 'Poppins_semibold',
                      color: Colors.white,
                      fontSize: fontsize.Buttonfontsize),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
