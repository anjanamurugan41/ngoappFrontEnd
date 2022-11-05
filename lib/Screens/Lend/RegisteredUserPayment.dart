
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
import 'package:ngo_app/Screens/Dashboard/Home.dart';

import 'package:ngo_app/ServiceManager/ApiProvider.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';


import 'PaymentScreen.dart';


class RegisterPaymentScrenn extends StatefulWidget {


  RegisterPaymentScrenn({Key key,  this.id, this.amount, this.paymentInfo,this.name,this.email,this.phone}) : super(key: key);
  final PaymentInfo paymentInfo;
final name;
final email;
final phone;

  final amount;
  final id;

  String amountInPaise = '0';
  @override
  State<RegisterPaymentScrenn> createState() => _RegisterPaymentScrennState();
}

class _RegisterPaymentScrennState extends State<RegisterPaymentScrenn> {
  BookingsBlocUser _bookingsBlocUser;
  PaymentInfo paymentInfo;

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

    try {
      TestPaymentModel response = await _bookingsBlocUser
          .RegisterPayment(widget.id,
        widget.amount.toString(),
       "Donation"


      );
      Get.back();
      print("StartTransaction->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
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
      Fluttertoast.showToast(msg:'Something went wrong. Please try again');
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
          Fluttertoast.showToast(msg:"Payment Succesfully Completed,Check bookings section");
        });


        await Future.delayed(Duration(seconds: 1));
        Get.offAll(() => Home());
      }).catchError((onError) {
        if (onError is PlatformException) {
          //AppDialogs.message("Payment failed, Please try again");
          setState(() {
            result = onError.message + " \n  " + onError.details.toString();
            Fluttertoast.showToast(msg:"Payment failed, Please try again");
          });
        } else {
          //AppDialogs.message("Payment failed, Please try again");
        }
      });
    } catch (err) {
      result = err.toString();
      Fluttertoast.showToast(msg:"Payment failed, Please try again");
    }
  }

  PaymentBlocUser _paymentBlocUser = PaymentBlocUser();
  Future _validateCheckSum(String OrderId) async {
    try {
      final response = await _paymentBlocUser.validateCheckSum(widget.name,widget.email,widget.phone,OrderId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      Fluttertoast.showToast(msg:'Something went wrong. Please try again');
    }
  }
}

