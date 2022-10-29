import 'dart:async';
import 'dart:convert';
import '../../Models/CommonResponse.dart';
import '../../ServiceManager/ApiProvider.dart';

class PaymentBlocUser {
  PaymentRepositoryUser _repository;

  PaymentBlocUser() {
    _repository = PaymentRepositoryUser();
  }

  Future<CommonResponse> validateCheckSum(String name,email,phone,orderid) async {
    try {
      CommonResponse response = await _repository.validateCheckSum(name,email,phone,orderid);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }
  Future<CommonResponse> validateCheckSumfund(String orderId, String fundraiserId) async {
    try {
      CommonResponse response = await _repository.validateCheckSumfund(orderId, fundraiserId);
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

  Future<CommonResponse> validateCheckSum(String name ,email,phone,orderid) async {
    final response = await apiProvider
        .getInstance()
        .post('paytm/transactionstatus'
        , data: {"name":name,"email":email,"phone":phone,"payment_type":"Donation","order_id":orderid});
    return CommonResponse.fromJson(jsonDecode(response.data));
  }
  Future validateCheckSumfund(String orderId, String fundraiserId) async {
    final response = await apiProvider
        .getInstance()
        .post('paytm/fundraiser-transaction-status'
        , data: {"order_id":orderId, "fundraiser_id": int.parse(fundraiserId)});
    return response.data;
  }
}
