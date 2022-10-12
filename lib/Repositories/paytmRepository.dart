import 'dart:convert';



import 'package:ngo_app/Models/paytmModel.dart';
import 'package:ngo_app/Screens/Lend/PaymentScreen.dart';

import '../../ServiceManager/ApiProvider.dart';
import 'package:http/http.dart'as http;

class TestRepositoryUser {
  ApiProvider apiProvider;
  PaymentInfo paymentInfo;
  TestRepositoryUser() {
    apiProvider = new ApiProvider();
  }

  Future<TestPaymentModel> getAllBookingList(int perPage, int page, paymentInfo) async {
    print("repository ->>>${ paymentInfo}");
    final response = await apiProvider.getInstance().post(
        'paytm/initiate',
        data: {
          "name":    paymentInfo.name,
          "amount":      paymentInfo.amount,
          "email": paymentInfo.email,
          "phone": paymentInfo.mobile});
    return TestPaymentModel.fromJson(response.data);
  }

  Future<TestPaymentModel> Paytmpay(
      String name,
      String amount,
      String email,
      String phone,
      ) async {
    final response = await apiProvider.getInstance().post(
        'paytm/initiate',
        data: {
          "name": name,
          "amount": amount,
          "email":email,
          "phone":phone});
    return TestPaymentModel.fromJson(response.data);
  }
// return response;

}
