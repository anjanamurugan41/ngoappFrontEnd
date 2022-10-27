import 'dart:async';
import 'dart:convert';


import '../../Models/CommonResponse.dart';
import '../../ServiceManager/ApiProvider.dart';

class PaymentBlocUser {
  PaymentRepositoryUser _repository;

  PaymentBlocUser() {
    _repository = PaymentRepositoryUser();
  }

  Future<CommonResponse> validateCheckSum(Map body) async {
    try {
      CommonResponse response = await _repository.validateCheckSum(body);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }
  Future<CommonResponse> validateCheckSumfund(String orderId) async {
    try {
      CommonResponse response = await _repository.validateCheckSumfund(orderId);
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

  Future<CommonResponse> validateCheckSum(Map responses) async {
    final response = await apiProvider
        .getInstance()
        .post('paytm/transactionstatus'
        , data: responses);
    return CommonResponse.fromJson(jsonDecode(response.data));
  }
  Future<CommonResponse> validateCheckSumfund(String orderId) async {
    print("order id is-------$orderId");
    final response = await apiProvider
        .getInstance()
        .post('paytm/fundraise-transaction-status'
        , data: orderId);
    return CommonResponse.fromJson(jsonDecode(response.data));
  }
}
