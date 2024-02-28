// ignore_for_file: prefer_const_constructors, file_names, camel_case_types, prefer_collection_literals, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/pages/authentication/login.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/common%20class/height.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/main.dart';
import 'package:single_ecommerce/pages/orders/orderdetails.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:single_ecommerce/widgets/my_bottom_navigationbar.dart';
import 'package:sizer/sizer.dart';
import '../../theme-old/thememodel.dart';
import '../cart/cartpage.dart';
import '../favorite/favoritepage.dart';
import '../orders/orders.dart';
import '../profile/profilepage.dart';
import 'homescreen.dart';

class cartcount extends GetxController {
  RxInt cartcountnumber = 0.obs;
}

class payloads {
  dynamic categoryName;
  dynamic categoryId;
  dynamic subType;
  dynamic itemId;
  dynamic type;
  dynamic orderId;

  payloads(
      {this.categoryName,
      this.categoryId,
      this.subType,
      this.itemId,
      this.type,
      this.orderId});

  payloads.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    subType = json['sub_type'];
    itemId = json['item_id'];
    type = json['type'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    data['sub_type'] = subType;
    data['item_id'] = itemId;
    data['type'] = type;
    data['order_id'] = orderId;
    return data;
  }
}

class Homepage extends StatefulWidget {
  int count = 3;
  Homepage(this.count, {super.key});
  // const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late StreamSubscription subscription;
  int? _selectedindex;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  Future<dynamic> onSelectNotification(payload) async {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Homepage(3),
        ),
      );
    }
  }

  late PageController pageController;

  @override
  void initState() {
    // getConnectivity();
    super.initState();
    pageController = PageController(initialPage: widget.count);
    _selectedindex = widget.count;

    getdata();
    FirebaseMessaging.instance;

    var initializationsettingsAndroid =
        const AndroidInitializationSettings('@drawable/ic_notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationsettingsAndroid);
    FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        String action = jsonEncode(message.data);

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                icon: '@drawable/ic_notification',
                channel.id,
                channel.name,
              ),
              iOS: IOSNotificationDetails()),
          payload: action,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          Get.to(() => Orderdetails("171"));
          loader.showErroDialog(description: "sfggfgdfdsd");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.body!),
                      ],
                    ),
                  ));
            },
          );
        }
      },
    );
  }

  String? userid;
  String? islogin;
  int cardcount = 0;
  cartcount count = Get.put(cartcount());

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    islogin = prefs.getString(UD_user_is_login_required);
    setState(() {
      if (islogin == "1") {
        _selectedindex = widget.count;
        userid = (prefs.getString(UD_user_id) ?? "");
        if (widget.count == 2 || widget.count == 3 || widget.count == 0) {
          pageController.animateToPage(
            widget.count,
            duration: const Duration(milliseconds: 1),
            curve: Curves.ease,
          );
        }
      }
    });
  }

  void onTapped(int index) {
    if (userid != "") {
      setState(() {
        _selectedindex = index;
        // widget.count = index;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      });
    } else {
      setState(() {
        _selectedindex = index;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // connections().conect();

    debugPrint(
        "faaz:login state: ${islogin == "1"} userId: ${(userid != " ")}");
    debugPrint("faaz:selected index: $_selectedindex, count: ${widget.count}");
    return Consumer(builder: (context, ThemeModel themenofier, child) {
      return OverlaySupport(
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () async {
            final value = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'ecommerce_User'.tr,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Poppins_semibold',
                        fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    'Are_you_sure_to_exit_from_this_app'.tr,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primarycolor,
                      ),
                      child: Text(
                        'No'.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primarycolor,
                      ),
                      child: Text(
                        'Yes'.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            if (value == true) {

      SystemNavigator.pop();
      return Future.value(false); 
    } else {
      return Future.value(false); 
    }
          },
          child: Scaffold(
            body: PageView(
              controller: pageController,
              pageSnapping: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Homescreen(),
                if (islogin == "1" && userid != "" && userid != "") ...[
                  Favorite()
                ],
                Viewcart(),
                if (islogin == "1" && userid != "" && userid != "") ...[
                  Orderhistory()
                ],
                Profilepage()
              ],
            ),
            bottomNavigationBar: Obx(() => MyBottomNavigationBar(
                  cartCount: count.cartcountnumber.value,
                  onPressed: onTapped,
                  islogin: islogin,
                  userid: userid,
                  currentIndex: widget.count,
                )),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    // Dispose of the PageController to free up resources.
    pageController.dispose();

    // Cancel the StreamSubscription to free up resources.
    subscription.cancel();

    super.dispose();
  }
}
