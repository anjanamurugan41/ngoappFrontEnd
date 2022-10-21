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
       int amount,
      String email,
      String phone,

      ) async {
    try {

      TestPaymentModel response =
      await _bookingRepository.Paytmpay(
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
