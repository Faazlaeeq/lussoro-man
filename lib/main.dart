import 'dart:io';

import 'package:single_ecommerce/onboarding/onboarding.dart';
import 'package:single_ecommerce/pages/Home/Homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/pages/splash_screen.dart';
import 'package:single_ecommerce/theme/mythemes.dart';
import 'package:single_ecommerce/theme/thememodel.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/translation/codegen_loader.g.dart';
import 'package:single_ecommerce/translation/stringtranslation.dart';
import 'package:sizer/sizer.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  //'This channel is used for important notifications.', // description
  importance: Importance.defaultImportance,

  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  ByteData data = await PlatformAssetBundle().load('Assets/CA/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(
        Brightness.light,
      ),
      child: Consumer(
        builder: (context, ThemeModel thememodel, child) {
          return Sizer(
            builder: (context, orientation, deviceType) {
              return Phoenix(
                  child: GetMaterialApp(
                    scrollBehavior: MyBehavior(),
                    fallbackLocale: const Locale('en', 'US'),
                    translations: Apptranslation(),
                    locale: const Locale('en', 'US'),
                    debugShowCheckedModeBanner: false,
                    theme: thememodel.isdark
                        ? MyThemes.DarkTheme
                        : MyThemes.LightTheme,
                    home: splash_screen(),
                  ));
            },
          );
        },
      ),
    ),
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}




//   commmands for generate localization string file 
//   flutter pub run easy_localization:generate -S "Assets/translation" -O "lib/translation"       
//   flutter pub run easy_localization:generate -S "Assets/translation" -O "lib/translation"       
//   flutter pub run easy_localization:generate -S "Assets/translation" -O "lib/translation" -o "locale_keys.g.dart" -f keys
