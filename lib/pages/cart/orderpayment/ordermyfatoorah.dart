
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:myfatoorah_flutter/embeddedapplepay/MFApplePayButton.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:single_ecommerce/pages/cart/orderpayment/orderpaystack.dart';
import 'package:single_ecommerce/widgets/loader.dart';

import '../../../model/settings/addwalletMODEL.dart';
import '../ordersucess.dart';


// You can get the API Token Key from here:
// https://myfatoorah.readme.io/docs/test-token
//  "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";

class order_myfatoorah extends StatefulWidget {
  String? ordertotal;
  String? ordertype;
  String? offercode;
  String? discountamount;
  String? taxamount;
  String? delivery_charge;
  //
  String? addresstype;
  String? address;
  String? area;
  String? houseno;
  String? lang;
  String? lat;
  //
  String? ordernote;
  //
  String? publickey;
  String? secretkey;
  String? encryption_key;
  String? currency;

  order_myfatoorah(
      this.ordertotal,
      this.ordertype,
      this.offercode,
      this.taxamount,
      this.discountamount,
      this.delivery_charge,
      //
      this.addresstype,
      this.address,
      this.area,
      this.houseno,
      this.lang,
      this.lat,
      //
      this.ordernote,
      //
      this.publickey,
      this.secretkey,
      this.encryption_key,
      this.currency,
      );

  @override
  _order_myfatoorahState createState() => _order_myfatoorahState();
}

class _order_myfatoorahState extends State<order_myfatoorah> {
  addwalletMODEL? addwalletdata;
  String? paymentid;
  String? userid;
  String? sessionid;
  String? lati_tude;
  String? longi_tude;
  String? confirm_Address;
  String? confirm_house;
  String? confirm_Area;
  String? Fullname;
  String? pref_email;
  String? pref_mobile;
  String? addresstype;

  String _response = '';
  String _loading = "Loading...";
  // late MFPaymentCardView mfPaymentCardView;
  late MFApplePayButton mfApplePayButton;

  @override
  void initState() {
    super.initState();
    // get();
    final String mAPIKey = widget.secretkey.toString();
    if (mAPIKey.isEmpty) {
      setState(() {
        _response =
        "Missing API Token Key.. You can get it from here: https://myfatoorah.readme.io/docs/test-token";
      });
      return;
    }

    MFSDK.init(mAPIKey, MFCountry.KUWAIT, MFEnvironment.TEST);
    initiateSession();

    MFSDK.setUpAppBar(isShowAppBar: false);

  }

  void initiateSession() {
    MFSDK.initiateSession(
        null,
            (MFResult<MFInitiateSessionResponse> result) => {
          if (result.isSuccess())
            {
              if (Platform.isIOS) loadApplePay(result.response!)
            }
          else
            {
              setState(() {
                _response = result.error!.message!;
              })
            }
        });
  }

  void loadApplePay(MFInitiateSessionResponse mfInitiateSessionResponse) {
    var request = MFExecutePaymentRequest.constructorForApplyPay(
        double.parse(widget.ordertotal.toString()), MFCurrencyISO.KUWAIT_KWD);
    mfApplePayButton.loadWithStartLoading(
        mfInitiateSessionResponse,
        request,
        MFAPILanguage.EN,
            () {
          setState(() {
            _response = "Loading...";
          });
        },
            (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
          if (result.isSuccess())
            {
              setState(() {
                print("invoiceId: " + invoiceId);
                print("Response: " + result.response!.toJson().toString());
                _response = result.response!.toJson().toString();
                paymentid = result.response!.invoiceTransactions![0].transactionId.toString();
                payment_API();
              })
            }
          else
            {
              setState(() {
                print("invoiceId: " + invoiceId);
                print("Error: " + result.error!.toJson().toString());
                _response = result.error!.message!;
              })
            }
        });
  }
 executeRegularPayment() {
  // The value 1 is the paymentMethodId of KNET payment method.
  // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
  int paymentMethod = 1;

  var request = new MFExecutePaymentRequest(paymentMethod, double.parse(widget.ordertotal.toString()));

  MFSDK.executePayment(context, request, MFAPILanguage.EN,
      onInvoiceCreated: (String invoiceId) =>
      {print("invoiceId: " + invoiceId)},
      onPaymentResponse: (String invoiceId,
          MFResult<MFPaymentStatusResponse> result) =>
      {
        if (result.isSuccess())
          {
            setState(() {
              print("invoiceId: " + invoiceId);
              print("Response: " + result.response!.toJson().toString());
              _response = result.response!.toJson().toString();
              paymentid = result.response!.invoiceTransactions![0].transactionId.toString();
              print(paymentid);
              payment_API();
            })
          }
        else
          {
            setState(() {
              print("invoiceId: " + invoiceId);
              print("Response: " + result.error!.toJson().toString());
              _response = result.error!.message!;
            })
          }
      });

  setState(() {
    _response = _loading;
  });
}
  payment_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     userid = prefs.getString(UD_user_id);
     sessionid = prefs.getString(UD_user_session_id);
     lati_tude = prefs.getString(latitude);
     longi_tude = prefs.getString(longitude);
     confirm_Address = prefs.getString(confirmAddress);
     confirm_house = prefs.getString(confirmhouse_no);
     confirm_Area = prefs.getString(confirmArea);
     Fullname = prefs.getString(Full_name);
     pref_email = prefs.getString(Email);
     pref_mobile = prefs.getString(Mobile_no);
     addresstype = prefs.getString(Addresstype);
    try {
      loader.showLoading();
      var map = {
        "user_id": userid,
        "session_id":sessionid,
        "grand_total": widget.ordertotal,
        "transaction_type": "8",
        "transaction_id": paymentid,
        "order_type": widget.ordertype,
        "address_type": userid == null || userid == "" ? addresstype : widget.addresstype,
        "address":  userid == null || userid == "" ? confirm_Address : widget.address,
        "area":  userid == null || userid == "" ? confirm_Area :widget.area,
        "house_no":  userid == null || userid == "" ? confirm_house :widget.houseno,
        "lang":  userid == null || userid == "" ? longi_tude :widget.lang,
        "lat":  userid == null || userid == "" ? lati_tude :widget.lat,
        "offer_code": widget.offercode == "0" ? "" : widget.offercode,
        "discount_amount": widget.discountamount,
        "tax_amount": widget.taxamount,
        "delivery_charge": widget.delivery_charge,
        "order_notes": widget.ordernote,
        "order_from": "flutter",
        "name":Fullname,
        "email":pref_email,
        "mobile":pref_mobile,
      };
      var finalAPI =
      await Dio().post(DefaultApi.appUrl + PostAPI.Order, data: map);
      var finallist = await finalAPI.data;
      add_money = addwalletMODEL.fromJson(finallist);

      if (add_money!.status == 1) {
        loader.hideLoading();
        prefs.setString(UD_user_wallet, add_money!.totalWallet.toString());
        int count = 0;

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Ordersucesspage();
          },
        ));
      } else {
        loader.hideLoading();
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 2;
        });
      }
      return add_money;
    } catch (e) {
      loader.hideLoading();
      loader.showErroDialog(description: "No Data Found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: executeRegularPayment(),
    );
  }
}
