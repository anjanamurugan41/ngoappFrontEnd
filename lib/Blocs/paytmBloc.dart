import 'dart:async';
import 'package:ngo_app/Models/paytmModel.dart';
import 'package:ngo_app/Repositories/paytmRepository.dart';
import 'package:ngo_app/Screens/Lend/PaymentScreen.dart';
import '../../Interfaces/LoadMoreListener.dart';
import '../../ServiceManager/ApiResponse.dart';


class BookingsBlocUser {
  TestRepositoryUser _bookingRepository;
  PaymentInfo paymentInfo;

  BookingsBlocUser({this.listener}) {
    if (_bookingRepository == null)
      _bookingRepository = TestRepositoryUser();

    _bookingListController =
    StreamController<ApiResponse<TestPaymentModel>>.broadcast();
  }

  bool hasNextPage = false;
  int pageNumber = 1;
  int perPage = 20;

  LoadMoreListener listener;

  StreamController<ApiResponse<TestPaymentModel>>
  _bookingListController;

  StreamSink<ApiResponse<TestPaymentModel>>
  get bookingDetailsListSink => _bookingListController.sink;

  Stream<ApiResponse<TestPaymentModel>> get bookingDetailsListStream =>
      _bookingListController.stream;


  Future<TestPaymentModel> bookAppointment(
      String name,
       String amount,
      String email,
      String phone,
      String paymentType

      ) async {
    try {

      TestPaymentModel response =
      await _bookingRepository.Paytmpay(
        name,
        amount.toString(),
        email,
       phone,
        paymentType

      );
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  Future<TestPaymentModel> RegisterPayment(
      int id,
      String amount,
      String payment_type


      ) async {
    try {

      TestPaymentModel response =
      await _bookingRepository.registerPay(
        id,
        amount.toString(),
        payment_type


      );
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }


  Future<TestPaymentModel> FundRaiser(
      String name,
      int amount,
      String email,
      String phone,

      ) async {
    try {

      TestPaymentModel response =
      await _bookingRepository.FundRaise(
        name,
        amount.toString(),
        email,
        phone,


      );
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }


// Future<String?> fetchGoogleMeetLink(String bookingId) async {
//   try {
//     final response = await _bookingRepository!.fetchGoogleMeetLink(bookingId);
//
//     try {
//       return response["link"]["meet_link"].toString();
//     } catch (e) {
//       return null;
//     }
//   } catch (e, s) {
//     Completer().completeError(e, s);
//   }
//   return null;
// }

//GET PRODUCT SAVED

}
