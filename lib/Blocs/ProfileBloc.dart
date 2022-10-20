import 'dart:async';
import 'dart:io';

import 'package:ngo_app/Models/PancardUploadResponse.dart';
import 'package:ngo_app/Models/UserDetails.dart';
import 'package:ngo_app/Repositories/AuthorisationRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Models/ProfileResponse.dart';
import '../ServiceManager/ApiResponse.dart';
import '../Utilities/LoginModel.dart';
import '../Utilities/PreferenceUtils.dart';

class ProfileBloc {
  AuthorisationRepository authorisationRepository;
  StreamController _profileController;
  StreamController _panController;
  StreamSink<ApiResponse<ProfileResponse>> get profileSink =>
      _profileController.sink;
  StreamSink<ApiResponse<PancardResponse>> get pancardsink =>
      _panController.sink;

  Stream<ApiResponse<ProfileResponse>> get profileStream =>
      _profileController.stream;

  Stream<ApiResponse<PancardResponse>> get pancardStream =>
      _panController.stream;
  ProfileBloc() {
    _profileController = StreamController<ApiResponse<ProfileResponse>>();
    authorisationRepository = AuthorisationRepository();
    _panController = StreamController<ApiResponse<PancardResponse>>();
  }


  getProfileInfo() async {
    profileSink.add(ApiResponse.loading('Fetching profile'));
    try {
      ProfileResponse profileResponse =
          await authorisationRepository.getProfileInfo();
      if (profileResponse.success) {
        if (profileResponse.userDetails != null) {
          LoginModel().userDetails = profileResponse.userDetails;
          LoginModel().userDetails.baseUrl = profileResponse.baseUrl;
          PreferenceUtils.setObjectToSF(
              PreferenceUtils.prefUserDetails, LoginModel().userDetails);
        }
        profileSink.add(ApiResponse.completed(profileResponse));
      } else {
        profileSink.add(ApiResponse.error(
            profileResponse.message ?? "Unable to process your request"));
      }
    } catch (error) {
      profileSink
          .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }



  dispose() {
    profileSink?.close();
    _profileController?.close();
  }
}
