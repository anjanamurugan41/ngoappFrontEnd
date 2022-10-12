
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ngo_app/Blocs/paymentchecksum.dart';
import 'package:ngo_app/Blocs/paytmBloc.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/paytmModel.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';

import 'package:ngo_app/ServiceManager/ApiProvider.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';


import 'PaymentScreen.dart';


class PatymPaymentScrenn extends StatefulWidget {
  PatymPaymentScrenn({Key key, this.paymentInfo}) : super(key: key);
  final PaymentInfo paymentInfo;
  String amountInPaise = '0';
  @override
  State<PatymPaymentScrenn> createState() => _PatymPaymentScrennState();
}

class _PatymPaymentScrennState extends State<PatymPaymentScrenn> {
  BookingsBlocUser _bookingsBlocUser;
  PaymentInfo paymentInfo;
  String result;
  @override
  void initState() {
    super.initState();
    paymentInfo = widget.paymentInfo;
    _bookingsBlocUser = BookingsBlocUser();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initPayment();
    });


  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12.withOpacity(0.5),
      body: Center(
        child: CommonApiLoader(),
      ),
    );
  }
  Future _initPayment() async {
    //  AppDialogs.loading();
    print("cc->>>>>>>${ paymentInfo.name}");
    try {
      TestPaymentModel response = await _bookingsBlocUser
          .bookAppointment(paymentInfo.name,
          paymentInfo.email,
          paymentInfo.mobile,
          paymentInfo.amount
      );
      Get.back();
      print("start Transaction------------------");
      await _startTransaction(
        response.mid,
        response.order_id,
        response.amount.toString(),
        response.body.txnToken,
      );
      print("mid->>>>>>>>>>>${ response.mid}");


    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      Text('Something went wrong. Please try again');
    }
  }

  _startTransaction(
      String mid,
      String orderId,
      String amount,
      String txnToken, {
        bool isStaging = false,
        restrictAppInvoke = true,
      }) async {
    try {
      var response = AllInOneSdk.startTransaction(
          mid,
          orderId,
          amount,
          txnToken,
          "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=${orderId}",
          isStaging,
          restrictAppInvoke);
      response.then((value) async {
        print("value=======>${value}");


        setState(() {
          result = value.toString();
          Text("Payment Succesfully Completed,Check bookings section");
        });
        await _validateCheckSum(value);

        await Future.delayed(Duration(seconds: 1));
        Get.offAll(() => Home());
      }).catchError((onError) {
        if (onError is PlatformException) {
          //AppDialogs.message("Payment failed, Please try again");
          setState(() {
            result = onError.message + " \n  " + onError.details.toString();
            Text("Payment failed, Please try again");
          });
        } else {
          //AppDialogs.message("Payment failed, Please try again");
          setState(() {
            result = onError.toString();
            Text("Payment failed, Please try again");
          });
        }
      });
    } catch (err) {
      result = err.toString();
      Text("Payment failed, Please try again");
    }
  }

  PaymentBlocUser _paymentBlocUser = PaymentBlocUser();
  Future _validateCheckSum(Map resp) async {
    try {
      CommonResponse response = await _paymentBlocUser.validateCheckSum(resp);
    } catch (e, s) {
      Completer().completeError(e, s);
      //Get.back();
      Text('Something went wrong. Please try again');
    }
  }
}

