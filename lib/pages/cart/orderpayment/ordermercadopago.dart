import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OrderMercadopago extends StatefulWidget {
  const OrderMercadopago({Key? key}) : super(key: key);

  @override
  State<OrderMercadopago> createState() => _OrderMercadopagoState();
}

class _OrderMercadopagoState extends State<OrderMercadopago> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    get();
  }
  String? url;
  String? successurl;
  String? failurl;
  String? transactionid;
  String? uriii;
  get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString(mercadopayurl);
    successurl = prefs.getString(mercadopaysuccessurl);
    failurl = prefs.getString(mercadopayfailurl);
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
          if(url.contains(successurl!) == true){
            var inputstring = url.toString();
            inputstring = inputstring.substring(inputstring.indexOf("?") + 1 , inputstring.indexOf("&"));
            transactionid = inputstring.replaceAll("collection_id=","");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(mercadopaytransctionid, transactionid.toString());
            Navigator.pop(context,true);
          }
          else if(url.contains(failurl!) == true){
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  _loadUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString(mercadopayurl)!;
    print("mercado pay url = $url");
    _webViewController.loadUrl(url);
  }
}
