// ignore_for_file: non_constant_identifier_names, file_names, duplicate_ignore, avoid_print, prefer_const_constructors, prefer_final_fields

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/model/authentication/forgotpasswordmodel.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:single_ecommerce/utils/validator.dart/validator.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({Key? key}) : super(key: key);

  @override
  State<Forgotpass> createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _Email = TextEditingController();
  Forgotpasswordmodel? Forgotpassdata;

  _Forgotpassword() async {
    try {
      loader.showLoading();
      var map = {
        "email": _Email.text.toString(),
      };
      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.forgotPassword, data: map);
      print(map);
      var finallist = await response.data;
      Forgotpassdata = Forgotpasswordmodel.fromJson(finallist);
      loader.hideLoading();
      if (Forgotpassdata!.status == 0) {
        loader.showErroDialog(description: Forgotpassdata!.message);
      } else if (Forgotpassdata!.status == 1) {
        _Email.clear();
        loader.showErroDialog(description: Forgotpassdata!.message);
      }
    } catch (e) {
      print(e);
    }
  }

  data() async {
    if (DefaultApi.environment == "sendbox") {
      setState(() {
        _Email.value = TextEditingValue(text: "user@gmail.com");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data();
  }

  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black,
                  size: 20,
                )),
            leadingWidth: 40,
          ),
          body: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                  top: 1.5.h,
                )),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 4.w, top: 3.h, bottom: 1.h),
                    child: Text('Forgot_Password'.tr,
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins_Bold'))),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      left: 4.w,
                      right: 4.w,
                    ),
                    child: Text(
                      'Enter_your_registered_email_address_below_We_will_send_new_password_in_your_email'.tr,
                      style:
                          const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 5.h, left: 4.w, right: 4.w),
                  child: Center(
                    child: TextFormField(
                      validator: (value) => Validators.validateEmail(value!),
                      cursorColor: Colors.black38,
                      controller: _Email,
                      decoration: InputDecoration(
                          hintText: Email.tr,
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 3.h, left: 4.w, right: 4.w),
                  height: 6.5.h,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      if (DefaultApi.environment == "sendbox") {
                        loader.showErroDialog(
                            description: LocaleKeys
                                    .This_operation_was_not_performed_due_to_demo_mode
                                .tr);
                      } else if (_formkey.currentState!.validate()) {
                        _Forgotpassword();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: color.primarycolor,
                    ),
                    child: Text(
                      'Submit'.tr,
                      style: const TextStyle(
                          fontFamily: 'Poppins_Bold',
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 17),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: Text(
                      'Dont_have_an_account'.tr,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 14),
                    )),
                Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Signup'.tr,
                          style: TextStyle(
                              fontFamily: 'Poppins_semiBold',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
