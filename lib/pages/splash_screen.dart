import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:single_ecommerce/onboarding/onboarding.dart';
import 'package:single_ecommerce/pages/Home/Homepage.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../model/authentication/loginrequiredmodel.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  int? initscreen;
  String? sessionid;

  @override
  void initState() {
    super.initState();
    login_required();
  }

  goup() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    initscreen = pref.getInt(init_Screen);
    await Future.delayed(const Duration(seconds: 1));
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return Homepage(0);
      },
    ));
  }

  login_required() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      loader.showErroDialog(
          description: "No internet connection,Exiting app...",
          onOk: () {
            exit(0);
          });
      return;
    }
    try {
      loginrequiredmodel? data;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      sessionid = (prefs.getString(UD_user_session_id) ?? "");
      var map = {};
      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.loginrequired, data: map);
      print(response);
      data = loginrequiredmodel.fromJson(response.data);
      if (data.status == 1) {
        if (sessionid == "" || sessionid == null) {
          prefs.setString(UD_user_session_id, data.sessionId.toString());
          print(data.sessionId.toString());
        }
        prefs.setString(
            UD_user_is_login_required, data.isLoginRequired.toString());
        print(data.isLoginRequired.toString());
        goup();
      } else {
        loader.showErroDialog(description: data.message);
      }
    } catch (e) {
      loader.showErroDialog(description: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "Assets/images/splash-bg-img.png",
      fit: BoxFit.fitWidth,
    );
  }
}
