import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ngo_app/Blocs/paymentchecksum.dart';
import 'package:ngo_app/Blocs/paytmBloc.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/paytmModel.dart';
import 'package:ngo_app/Repositories/paytmRepository.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';

import 'package:ngo_app/ServiceManager/ApiProvider.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

import 'PaymentScreen.dart';

class PaytmFundRaiserScreen extends StatefulWidget {
  PaytmFundRaiserScreen(
      {Key key,
      this.name,
      this.email,
      this.phonenumber,
      this.amount,
      this.paymentInfo,
      this.fundraise_id})
      : super(key: key);
  final PaymentInfo paymentInfo;
  final email;
  final phonenumber;
  final amount;
  final name;

  final fundraise_id;
  String amountInPaise = '0';

  @override
  State<PaytmFundRaiserScreen> createState() => _PaytmFundRaiserScreenState();
}

class _PaytmFundRaiserScreenState extends State<PaytmFundRaiserScreen> {
  BookingsBlocUser _bookingsBlocUser;
  PaymentInfo paymentInfo;
  TestRepositoryUser intitatefund = TestRepositoryUser();

  String result;

  @override
  void initState() {
    super.initState();
    paymentInfo = paymentInfo;
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
    print("cc->>>>>>>${widget.amount}");
    try {
      TestPaymentModel response = await _bookingsBlocUser.FundRaiser(
          widget.name,
          widget.amount,
          widget.email,
          widget.phonenumber,
          );
      Get.back();
      print("StartTransaction->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      await _startTransaction(
        response.mid,
        response.order_id,
        response.amount.toString(),
        response.body.txnToken,
      );
      await intitatefund.InitiateFundRaise(response.amount.toString(),
         response.body.txnToken, response.order_id,widget.fundraise_id);
      print("mid->>>>>>>>>>>${response.mid}");
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
    bool isStaging = true,
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
        await _validateCheckSum(value["ORDERID"]);
        setState(() {
          result = value.toString();
          Fluttertoast.showToast(msg: "Payment Succesfully Completed,Check bookings section");
        });


      //  await Future.delayed(Duration(seconds: 1));
        Get.offAll(() => Home());
      }).catchError((onError) {
        if (onError is PlatformException) {
          //AppDialogs.message("Payment failed, Please try again");
          setState(() async {
            result = onError.message + " \n  " + onError.details.toString();
            Fluttertoast.showToast(msg: "Payment failed, Please try again");
            await _validateCheckSum(onError.details["ORDERID"]);
          });
        } else {
          //AppDialogs.message("Payment failed, Please try again");
          // setState(() async {
          //   result = onError.toString();
          //   Fluttertoast.showToast(msg: "Payment failed, Please try again");
          //   await _validateCheckSum(onError.details["ORDERID"]);
          // });
        }
      });
    } catch (err) {
      result = err.toString();
      Fluttertoast.showToast(msg: "Payment failed, Please try again");
    }
  }

  PaymentBlocUser _paymentBlocUser = PaymentBlocUser();

  Future _validateCheckSum(String orderId) async {
    // AppDialogs.loading();
    try {
      final response =
          await _paymentBlocUser.validateCheckSumfund(orderId, widget.fundraise_id.toString());

      Get.back();
      Fluttertoast.showToast(msg: "Payment Success");
return response;
    } catch (e, s) {
      Completer().completeError(e, s);
     // Get.back();
      Fluttertoast.showToast(msg:"Success");
    }
  }
}
