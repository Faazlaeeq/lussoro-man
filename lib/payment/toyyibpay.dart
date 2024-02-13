import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Toyyibpay extends StatefulWidget {
  const Toyyibpay({Key? key}) : super(key: key);

  @override
  State<Toyyibpay> createState() => _ToyyibpayState();
}

class _ToyyibpayState extends State<Toyyibpay> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    get();
  }
  String? url;
  String? billcode;
  String? successurl;
  String? failurl;
  String? transactionid;
  String? uriii;
  get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString(toyyibpayurl);
    billcode = prefs.getString(toyyibpaybillcode);
    successurl = prefs.getString(toyyibpaysuccessurl);
    failurl = prefs.getString(toyyibpayfailurl);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        zoomEnabled: true,
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _loadUrl();
        },
        onPageStarted: (url) async {
          if (url.contains(successurl!) == true){
            transactionid = url.replaceAll(successurl!,"").replaceAll("?status_id=1&billcode=","").replaceAll(billcode!,"").replaceAll("&order_id=&msg=ok&transaction_id=","");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(toyyibpaytransctionid, transactionid.toString());
            Navigator.pop(context,true);
          }
          else if (url.contains(failurl!) == true){
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  _loadUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString(toyyibpayurl)!;
    print("toyyib pay url = $url");
    _webViewController.loadUrl(url);
  }
}
