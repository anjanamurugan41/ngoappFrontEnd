import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Models/CommonResponse.dart';
import '../../ServiceManager/ApiProvider.dart';

class PaymentBlocUser {
  PaymentRepositoryUser _repository;

  PaymentBlocUser() {
    _repository = PaymentRepositoryUser();
  }

  Future validateCheckSum(String name,email,phone,orderid) async {
    try {
     final  response = await _repository.validateCheckSum(name,email,phone,orderid);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }
  Future validateCheckSumfund(String orderId, String fundraiserId) async {
    try {
      final response = await _repository.validateCheckSumfund(orderId, fundraiserId);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }
}


class PaymentRepositoryUser {
  ApiProvider apiProvider;

  PaymentRepositoryUser() {
    apiProvider = new ApiProvider();
  }

  Future validateCheckSum(String name ,email,phone,orderid) async {
    final response = await apiProvider
        .getInstance()
        .post('paytm/transactionstatus'
        , data: {"name":name,"email":email,"phone":phone,"payment_type":"Donation","order_id":orderid});
    Get.back();
    Fluttertoast.showToast(msg:"Payment Success");
    return response;
  }
  Future validateCheckSumfund(String orderId, String fundraiserId) async {
    final response = await apiProvider
        .getInstance()
        .post('paytm/fundraiser-transaction-status'
        , data: {"order_id":orderId, "fundraiser_id": int.parse(fundraiserId)});
    return response;
  }
}
