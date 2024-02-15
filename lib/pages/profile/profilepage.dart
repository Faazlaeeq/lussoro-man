// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names, prefer_final_fields, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:single_ecommerce/pages/authentication/login.dart';
import 'package:single_ecommerce/theme-old/thememodel.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/common%20class/height.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/pages/Home/Homepage.dart';
import 'package:single_ecommerce/pages/profile/faqs.dart';
import 'package:single_ecommerce/pages/profile/wallet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart' as Size;
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:single_ecommerce/widgets/common_widgets.dart';
import 'aboutus.dart';
import 'gallary.dart';
import 'helpcontectus.dart';
import 'package:sizer/sizer.dart';
import 'notification.dart';
import 'privacy.dart';
import 'refer_earn.dart';
import 'testimonial.dart';
import 'changepass.dart';
import 'editprofile.dart';
import 'manage address.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}
class OptionTileModel{
  String text;
  void Function() fucn;
  String imgUrl;

  OptionTileModel(this.text, this.fucn, this.imgUrl);
}
class _ProfilepageState extends State<Profilepage> {
  String userid = "";
  String islogin = "";
  String username = "";
  String useremail = "";
  String userprofile = "";
  String user_logintype = "";
  String check_addons = "";
  bool? status;
  cartcount _cartcount = Get.put(cartcount());



  @override
  void initState() {
    super.initState();
    getprefs_data();
    data();
  }

  data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    islogin = prefs.getString(UD_user_is_login_required)!;
    print("is login data = ${prefs.getString(UD_user_is_login_required)}");
  }

  getprefs_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString(UD_user_id)!;
      print(userid);
      useremail = (prefs.getString(UD_user_email) ?? 'Guest');
      username = (prefs.getString(UD_user_name) ?? 'Guest');
      userprofile = (prefs.getString(UD_user_profileimage)!);
      user_logintype = (prefs.getString(UD_user_logintype)!);
      check_addons = (prefs.getString(App_check_addons)!);
      print(userprofile);
    });
  }

  user() {
    return null;
  }

  @override
  Widget build(BuildContext context) {



    List<OptionTileModel> pageContent= [
      ...[if (islogin == "1") ...[
        if (user_logintype == "email" &&
            check_addons == "email")OptionTileModel('Change_Password'.tr, () {
          userid == ""
              ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (c) => Login()),
                  (r) => false)
              : Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  const Changepass()));
        }, "Assets/Icons/password.png"),
      ]],
      ...[  if (islogin == "1")...[OptionTileModel('My_Addresses'.tr,() {
        // print(userdata!.data!.wallet);
        userid == ""
            ? Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (c) => Login()),
                (r) => false)
            : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Wallet()));
      },"Assets/Icons/address2.png")]],...[  if (islogin == "1")...[OptionTileModel('Testimonials'.tr,() {
        userid == ""
            ? Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (c) => Login()),
                (r) => false)
            : Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const Ratingreview()),
        );
      },"Assets/Icons/testinomials.png")]],
      ...[  if (islogin == "1")...[OptionTileModel('Refer_Earn'.tr,() {
        userid == ""
            ? Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (c) => Login()),
                (r) => false)
            : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const Refer_earn()));
      },"Assets/Icons/earn-with-bg.png")]],
      ...[  if (islogin == "1")...[OptionTileModel('Notification_Settings'.tr,() {
        userid == ""
            ? Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (c) => Login()),
                (r) => false)
            : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const Notificationpage()));
      },"Assets/Icons/notification-with-bg.png")]],
       ...[  if (islogin == "1")...[OptionTileModel('Help_Contact_Us'.tr,() {
         Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) => Helpcontactus()),
         );
       },"Assets/Icons/help2-with-bg.png")]],
      ...[OptionTileModel('Privacy_Policy'.tr,() {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Privacypolicy()),
        );
      },"Assets/Icons/privacy2-with-bg.png")],
      ...[OptionTileModel('Faqs'.tr,() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Faqs()),
        );
      },"Assets/Icons/faq2-with-bg.png")] ,  ...[OptionTileModel('About_us'.tr, () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => Aboutus()),
    );
    },
      "Assets/Icons/aboutus-with-bg.png")],
     ...[  if (islogin == "1") ...[OptionTileModel( userid == "" ? 'Login'.tr : 'Logout'.tr, () {
        userid == ""
            ? Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (c) => Login()),
                (r) => false)
            : showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'ecommerce_User'.tr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Poppins_bold',
                  ),
                ),
                content: Text(
                  LocaleKeys
                      .Are_you_sure_to_logout_from_this_app
                      .tr,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Poppins'),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      color.primarycolor,
                    ),
                    child: Text(
                      'Logout'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                      await SharedPreferences
                          .getInstance();
                      // prefs.clear();
                      prefs.remove(UD_user_id);
                      prefs.remove(UD_user_name);
                      prefs.remove(UD_user_email);
                      _cartcount
                          .cartcountnumber.value = 0;
                      Navigator.of(context)
                          .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (c) =>
                                  Login()),
                              (r) => false);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      color.primarycolor,
                    ),
                    child: Text(
                      'Cancel'.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
          "Assets/Icons/loginout.png"//conditional Image
      )]]];

    return Consumer(builder: (context, ThemeModel themenofier, child) {
      return SafeArea(
          child: Scaffold(
            
              body: SingleChildScrollView(
                  child: Column(
        children: [
          Container(
            child: Column(
              children: [
                //Header
                profileHeader(context, themenofier),
                Container(
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: MyColors.outlineColorOnLight, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: Size.padding4, vertical: Size.padding1),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: Size.padding2),
                    child: Column(
                        children: List.generate(
                            pageContent.length,((index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Size.padding1, vertical: Size.padding1),
                          child: ListTile(
                            leading: Image.asset(pageContent[index].imgUrl,height: 40,width:40),
                            title: Text(pageContent[index].text,
                                style:
                                Theme.of(context).textTheme.titleSmall),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                            ),
                            onTap:pageContent[index].fucn,
                          ),
                        ))),

            ),
          )
        ],
      ))]))));
    });
  }

  Padding listofOptions(ThemeModel themenofier, BuildContext context) {
    return Padding(
                padding: EdgeInsets.only(
                  left: 3.5.w,
                  right: 3.5.w,
                ),
                child: Column(children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 1.h,
                        ),
                        height: height.settingsheight,
                        child: Row(
                          children: [
                            Text(
                              'Settings'.tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Poppins_semibold',
                                color: themenofier.isdark
                                    ? Colors.white
                                    : color.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (islogin == "1") ...[
                        if (user_logintype == "email" &&
                            check_addons == "email") ...[
                          InkWell(
                            onTap: () {
                              userid == ""
                                  ? Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (c) => Login()),
                                      (r) => false)
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Changepass()));
                            },
                            child: Container(
                              height: height.settingsheight,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'Assets/svgicon/Lock.svg',
                                    height: height.settingiconheight,
                                    color: themenofier.isdark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 3.3.w,
                                      right: 3.3.w,
                                    ),
                                    child: Text(
                                      'Change_Password'.tr,
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          fontFamily: 'Poppins'),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 13.sp,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 0.8.sp,
                            width: MediaQuery.of(context).size.width,
                            color: themenofier.isdark
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ],
                      ],
                      if (islogin == "1") ...[
                        InkWell(
                          onTap: () {
                            userid == ""
                                ? Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => Login()),
                                    (r) => false)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Manage_Addresses()));
                          },
                          child: Container(
                            height: height.settingsheight,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'Assets/svgicon/Address.svg',
                                  height: height.settingiconheight,
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 3.3.w,
                                    right: 3.3.w,
                                  ),
                                  child: Text(
                                    'My_Addresses'.tr,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13.sp,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 0.8.sp,
                          width: MediaQuery.of(context).size.width,
                          color:
                              themenofier.isdark ? Colors.white : Colors.grey,
                        ),
                      ],
                      if (islogin == "1") ...[
                        InkWell(
                          onTap: () {
                            // print(userdata!.data!.wallet);
                            userid == ""
                                ? Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => Login()),
                                    (r) => false)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wallet()));
                          },
                          child: Container(
                            height: height.settingsheight,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'Assets/svgicon/Wallet.svg',
                                  height: height.settingiconheight,
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 3.3.w,
                                    right: 3.3.w,
                                  ),
                                  child: Text(
                                    'My_Wallet'.tr,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13.sp,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 0.8.sp,
                          width: MediaQuery.of(context).size.width,
                          color:
                              themenofier.isdark ? Colors.white : Colors.grey,
                        ),
                      ],
                      if (islogin == "1") ...[
                        InkWell(
                          onTap: () {
                            userid == ""
                                ? Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => Login()),
                                    (r) => false)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Ratingreview()),
                                  );
                          },
                          child: Container(
                            height: height.settingsheight,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'Assets/svgicon/Testimonial.svg',
                                  height: height.settingiconheight,
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 3.3.w,
                                    right: 3.3.w,
                                  ),
                                  child: Text(
                                    'Testimonials'.tr,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13.sp,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 0.8.sp,
                          width: MediaQuery.of(context).size.width,
                          color:
                              themenofier.isdark ? Colors.white : Colors.grey,
                        ),
                      ],
                      if (islogin == "1") ...[
                        InkWell(
                          onTap: () {
                            userid == ""
                                ? Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => Login()),
                                    (r) => false)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Refer_earn()));
                          },
                          child: Container(
                            height: height.settingsheight,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'Assets/svgicon/Referearn.svg',
                                  height: height.settingiconheight,
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 3.3.w,
                                    right: 3.3.w,
                                  ),
                                  child: Text(
                                    'Refer_Earn'.tr,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13.sp,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 0.8.sp,
                          width: MediaQuery.of(context).size.width,
                          color:
                              themenofier.isdark ? Colors.white : Colors.grey,
                        ),
                      ],
                      if (islogin == "1") ...[
                        InkWell(
                          onTap: () {
                            userid == ""
                                ? Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => Login()),
                                    (r) => false)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Notificationpage()));
                          },
                          child: Container(
                            height: height.settingsheight,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'Assets/svgicon/Notification.svg',
                                  height: height.settingiconheight,
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 3.3.w,
                                    right: 3.3.w,
                                  ),
                                  child: Text(
                                    'Notification_Settings'.tr,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13.sp,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 0.8.sp,
                          width: MediaQuery.of(context).size.width,
                          color:
                              themenofier.isdark ? Colors.white : Colors.grey,
                        ),
                      ],
                      InkWell(
                        onTap: () {
                          _showbottomsheet();
                        },
                        child: Container(
                          height: height.settingsheight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'Assets/svgicon/Changelayout.svg',
                                height: height.settingiconheight,
                                color: themenofier.isdark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 3.3.w,
                                  right: 3.3.w,
                                ),
                                child: Text(
                                  'Change_Layout'.tr,
                                  style: TextStyle(
                                      fontSize: 10.sp, fontFamily: 'Poppins'),
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13.sp,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8.sp,
                        width: MediaQuery.of(context).size.width,
                        color:
                            themenofier.isdark ? Colors.white : Colors.grey,
                      ),
                      if (islogin == "1") ...[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Helpcontactus()),
                            );
                          },
                          child: Container(
                            height: height.settingsheight,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'Assets/svgicon/Help.svg',
                                  height: height.settingiconheight,
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 3.3.w,
                                    right: 3.3.w,
                                  ),
                                  child: Text(
                                    'Help_Contact_Us'.tr,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13.sp,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 0.8.sp,
                          width: MediaQuery.of(context).size.width,
                          color:
                              themenofier.isdark ? Colors.white : Colors.grey,
                        ),
                      ],
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Privacypolicy()),
                          );
                        },
                        child: Container(
                          height: height.settingsheight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'Assets/svgicon/Privacypolicy.svg',
                                height: height.settingiconheight,
                                color: themenofier.isdark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 3.3.w,
                                  right: 3.3.w,
                                ),
                                child: Text(
                                  'Privacy_Policy'.tr,
                                  style: TextStyle(
                                      fontSize: 10.sp, fontFamily: 'Poppins'),
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13.sp,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8.sp,
                        width: MediaQuery.of(context).size.width,
                        color:
                            themenofier.isdark ? Colors.white : Colors.grey,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Aboutus()),
                          );
                        },
                        child: Container(
                          height: height.settingsheight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'Assets/svgicon/Aboutus.svg',
                                height: height.settingiconheight,
                                color: themenofier.isdark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 3.3.w,
                                  right: 3.3.w,
                                ),
                                child: Text(
                                  'About_Us'.tr,
                                  style: TextStyle(
                                      fontSize: 10.sp, fontFamily: 'Poppins'),
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13.sp,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8.sp,
                        width: MediaQuery.of(context).size.width,
                        color:
                            themenofier.isdark ? Colors.white : Colors.grey,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Faqs()),
                          );
                        },
                        child: Container(
                          height: height.settingsheight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'Assets/svgicon/Order.svg',
                                height: height.settingiconheight,
                                color: themenofier.isdark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 3.3.w,
                                  right: 3.3.w,
                                ),
                                child: Text(
                                  'Faqs'.tr,
                                  style: TextStyle(
                                      fontSize: 10.sp, fontFamily: 'Poppins'),
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13.sp,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8.sp,
                        width: MediaQuery.of(context).size.width,
                        color:
                            themenofier.isdark ? Colors.white : Colors.grey,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Gallary()),
                          );
                        },
                        child: Container(
                          height: height.settingsheight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'Assets/svgicon/Gallary.svg',
                                height: height.settingiconheight,
                                color: themenofier.isdark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 3.3.w,
                                  right: 3.3.w,
                                ),
                                child: Text(
                                  'Gallery'.tr,
                                  style: TextStyle(
                                      fontSize: 10.sp, fontFamily: 'Poppins'),
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13.sp,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8.sp,
                        width: MediaQuery.of(context).size.width,
                        color:
                            themenofier.isdark ? Colors.white : Colors.grey,
                      ),
                      InkWell(
                        child: Container(
                          height: height.settingsheight,
                          child: Row(
                            children: [
                              Image.asset(
                                'Assets/Icons/darkmode.png',
                                height: height.settingiconheight,
                                color: themenofier.isdark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 3.3.w,
                                  right: 3.3.w,
                                ),
                                child: Text(
                                  'Darkmode'.tr,
                                  style: TextStyle(
                                      fontSize: 10.sp, fontFamily: 'Poppins'),
                                ),
                              ),
                              Spacer(),
                              Switch.adaptive(
                                  inactiveTrackColor: Colors.grey,
                                  activeColor: Colors.white,
                                  inactiveThumbColor: Colors.black,
                                  value: themenofier.isdark ? true : false,
                                  onChanged: (value) {
                                    themenofier.isdark
                                        ? themenofier.isDark = false
                                        : themenofier.isDark = true;
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 0.8.sp,
                        width: MediaQuery.of(context).size.width,
                        color:
                            themenofier.isdark ? Colors.white : Colors.grey,
                      ),
                      if (islogin == "1") ...[
                        InkWell(
                          onTap: () {
                            userid == ""
                                ? Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (c) => Login()),
                                    (r) => false)
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'ecommerce_User'.tr,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Poppins_bold',
                                          ),
                                        ),
                                        content: Text(
                                          LocaleKeys
                                              .Are_you_sure_to_logout_from_this_app
                                              .tr,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontFamily: 'Poppins'),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  color.primarycolor,
                                            ),
                                            child: Text(
                                              'Logout'.tr,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            onPressed: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              // prefs.clear();
                                              prefs.remove(UD_user_id);
                                              prefs.remove(UD_user_name);
                                              prefs.remove(UD_user_email);
                                              _cartcount
                                                  .cartcountnumber.value = 0;
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (c) =>
                                                              Login()),
                                                      (r) => false);
                                            },
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  color.primarycolor,
                                            ),
                                            child: Text(
                                              'Cancel'.tr,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                          },
                          child: Container(
                            height: height.settingsheight,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'Assets/svgicon/Logout.svg',
                                  height: height.settingiconheight,
                                  color: themenofier.isdark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Container(
                                  // alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                    left: 3.3.w,
                                    right: 3.3.w,
                                  ),
                                  child: Text(
                                    userid == "" ? 'Login'.tr : 'Logout'.tr,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 13.sp,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 0.8.sp,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black12,
                        ),
                      ],
                    ],
                  )
                ]),
              );
  }

  Container profileHeader(BuildContext context, ThemeModel themenofier) {
    return Container(
                height: 23.h,
                width: MediaQuery.of(context).size.width,
                color: themenofier.isdark ? Colors.white : color.black,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 4.w, right: 4.w, top: 5.w),
                          child: Text(
                            'Myprofile'.tr,
                            style: TextStyle(
                                color: themenofier.isdark
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 15.sp,
                                fontFamily: 'Poppins_semibold'),
                          ),
                        ),
                        Spacer(),
                        if (islogin == "1") ...[
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),

                              ),
                              height: 5.h,
                              width: 5.h,
                              margin: EdgeInsets.only(top: 3.5.h),
                              child: InkWell(
                                  onTap: () {
                                    userid == ""
                                        ? Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (c) => Login()),
                                                (r) => false)
                                        : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Editprofile()))
                                            .then((value) {
                                            getprefs_data();
                                          });
                                  },
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'Assets/svgicon/Edit.svg',

                                    ),
                                  ))),
                        ],
                        Padding(padding: EdgeInsets.only(right: 4.8.w)),
                      ],
                    ),
                    if (username == "")
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Size.padding2),
                        child: CommonWidgets.customListTile(
                            context: context,
                            name: 'Guest',
                            nameTheme: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 18),
                            imageUrl: AssetImage(
                                'Assets/Image/defaultuserprofile.png'),
                            subtitle: "guest@gmail.com",
                            verticalPadding: Size.padding2,
                            horizontalPadding: Size.padding2,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            subtitleStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 12,
                                    color: MyColors.subtitleColor)),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Size.padding2),
                        child: CommonWidgets.customListTile(
                            context: context,
                            name: username,
                            nameTheme: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 18),
                            imageUrl: NetworkImage(userprofile.toString()),
                            subtitle: useremail,
                            verticalPadding: Size.padding2,
                            horizontalPadding: Size.padding2,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            subtitleStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 12,
                                    color: MyColors.subtitleColor)),
                      ),
                  ],
                ),
              );
  }

  _showbottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(7)),
              height: 30.h,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 2.h,
                      bottom: 2.h,
                    ),
                    child: Text('Select_application_layout'.tr,
                        style: TextStyle(
                            fontSize: 9.5.sp,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                  ),
                  Container(
                    height: 0.8.sp,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black12,
                  ),
                  TextButton(
                    onPressed: () async {
                      await Get.updateLocale(Locale('en', 'US'));
                      Phoenix.rebirth(context);
                      Navigator.of(context).pop();
                    },
                    child: Text('LTR'.tr,
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Poppins_semibold',
                            color: Colors.grey)),
                  ),
                  Container(
                    height: 0.8.sp,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black12,
                  ),
                  TextButton(
                      onPressed: () async {
                        await Get.updateLocale(Locale('ar', 'ab'));
                        Navigator.of(context).pop();
                        Phoenix.rebirth(context);
                      },
                      child: Text('RTL'.tr,
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey,
                              fontFamily: 'Poppins_semibold'))),
                  Container(
                    height: 0.8.sp,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black12,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel'.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins_semibold',
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }
}
