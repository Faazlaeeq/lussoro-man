// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_ecommerce/model/settings/privacymodel.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Privacypolicy extends StatefulWidget {
  const Privacypolicy({Key? key}) : super(key: key);

  @override
  State<Privacypolicy> createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  String privacycode = "";
  cmsMODEL? privacydata;
  PrivacyAPI() async {
    var response = await Dio().get(DefaultApi.appUrl + GetAPI.cmspages);
    privacydata = cmsMODEL.fromJson(response.data);
    privacycode = privacydata!.privacypolicy!;
    return cmsMODEL;
  }

  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          style: ButtonStyle(backgroundColor: MyColors.mPrimaryColor),
          icon: ImageIcon(
            AssetImage("Assets/Icons/arrow-smooth-left.png"),
            color: MyColors.secondaryColor,
            size: 20,
          ),
        ),
        title: Text(
          'Privacy_Policy'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Poppins_semibold', fontSize: 12.sp),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: PrivacyAPI(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: color.primarycolor,
              ),
            );
          }
          return WebView(
            javascriptMode: JavascriptMode.unrestricted,
            zoomEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              _loadHtmlFromAssets();
            },
          );
        },
      ),
    ));
  }

  _loadHtmlFromAssets() async {
    _controller.loadUrl(Uri.dataFromString(privacycode,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
