import 'dart:async';
import 'dart:io';

import 'package:ngo_app/Models/CommonResponse.dart';
import 'package:ngo_app/Models/PancardUploadResponse.dart';
import 'package:ngo_app/Models/UserDetails.dart';
import 'package:ngo_app/Repositories/AuthorisationRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Models/ProfileResponse.dart';
import '../ServiceManager/ApiResponse.dart';
import '../Utilities/LoginModel.dart';
import '../Utilities/PreferenceUtils.dart';

class PanBloc {
  AuthorisationRepository authorisationRepository;

  StreamController _panController;

  StreamSink<ApiResponse<PancardResponse>> get pancardsink =>
      _panController.sink;


  Stream<ApiResponse<PancardResponse>> get pancardStream =>
      _panController.stream;
  PanBloc() {

    authorisationRepository = AuthorisationRepository();
    _panController = StreamController<ApiResponse<PancardResponse>>();
  }


  getpancardinfo(file) async {
    pancardsink.add(ApiResponse.loading('Fetching profile'));
    try {
      PancardResponse pancardResponse =
      await authorisationRepository.pancardupload( file);
      if (pancardResponse.success) {
        if (pancardResponse.userDetails != null) {
          LoginModel().userDetails.pancardimage=pancardResponse.userDetails.pancard_image;
          LoginModel().userDetails.baseUrl = pancardResponse.baseUrl;
          PreferenceUtils.setObjectToSF(
              PreferenceUtils.prefUserDetails, LoginModel().userDetails);
        }
        pancardsink.add(ApiResponse.completed(pancardResponse));
      } else {
        pancardsink.add(ApiResponse.error(
            pancardResponse.message ?? "Unable to process your request"));
      }
    } catch (error) {
      pancardsink
          .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  Future<PancardResponse> uploadUserRecords(
     File reportFile) async {
    try {
      PancardResponse response =
      (await authorisationRepository.pancardupload(reportFile));
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
      throw e;
    }
  }

  dispose() {
    pancardsink?.close();
    _panController?.close();
  }
}
