import 'dart:convert';



import 'package:ngo_app/Models/UserDetails.dart';
import 'package:ngo_app/Models/paytmModel.dart';
import 'package:ngo_app/Screens/Lend/PaymentScreen.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';
import 'package:ngo_app/Utilities/PreferenceUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ServiceManager/ApiProvider.dart';
import 'package:http/http.dart'as http;

class TestRepositoryUser {
  ApiProvider apiProvider;
  //PaymentInfo paymentInfo;
  TestRepositoryUser() {
    apiProvider = new ApiProvider();
  }
  UserDetails userDetails;
  Future<TestPaymentModel> getAllBookingList(int perPage, int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(PreferenceUtils.prefUserDetails) ?? "";
    userDetails = UserDetails.fromJson(json.decode(data));
    LoginModel().userDetails = userDetails;
    final response = await apiProvider.getInstance().post(
        'paytm/initiate',
        data: {
          "name": userDetails.name,
          "amount": 1,
          "email": userDetails.email,
          "phone":userDetails.phoneNumber,
          "payment_type":"Donation"
       });
    return TestPaymentModel.fromJson(response.data);
  }

  Future<TestPaymentModel> Paytmpay(
      String name,
      String amount,
      String email,
      String phone,
      String paymentype
      ) async {
    final response = await apiProvider.getInstance().post(
        'paytm/initiate',
        data: {
          "name": name,
          "amount": amount,
          "email":email,
          "phone":phone,
        "payment_type":"Donation"});
    return TestPaymentModel.fromJson(response.data);
  }
// return response;
  Future<TestPaymentModel> registerpayment(int perPage, int page,amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(PreferenceUtils.prefUserDetails) ?? "";
    userDetails = UserDetails.fromJson(json.decode(data));
    LoginModel().userDetails = userDetails;
    final response = await apiProvider.getInstance().post(
        'paytm/initiate',
        data: {
          "id": userDetails.id,
          "amount":amount,

        });
    return TestPaymentModel.fromJson(response.data);
  }

  Future<TestPaymentModel> registerPay(
      int id,
      String amount,
      String donation

      ) async {
    final response = await apiProvider.getInstance().post(
        'paytm/initiate',
        data: {
          "user_id": id,
          "amount": amount,
          "payment_type":donation

          });
    return TestPaymentModel.fromJson(response.data);
  }
  Future<TestPaymentModel> FundRaise(
      String name,
      String amount,
      String email,
      String phone,

      ) async {
    final response = await apiProvider.getInstance().post(
        'paytm/fundraiser-initiate',
        data: {
          "name": name,
          "amount": amount,
          "email":email,
          "phone":phone,


        });
    return TestPaymentModel.fromJson(response.data);
  }
  Future InitiateFundRaise(
      String amount,
      String token,
      String order_id,
      int fundraiser_id
      ) async {
    final response = await apiProvider.getInstance().post(
        'paytm/update-fundraiser-amount',
        data: {
          "amount": 20,
          "txntoken":token,
          "order_id":order_id,
          "fundraiser_id":fundraiser_id
        });
    print("response->>>>>>>>>>>${response.data}");
    return response;

  }

}
