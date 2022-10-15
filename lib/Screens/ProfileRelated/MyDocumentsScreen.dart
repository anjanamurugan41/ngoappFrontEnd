import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CommonWidgets.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/EnumValues.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/ImagePickerAndCropper/image_picker_handler.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/TextDrawableWidget.dart';
import 'package:ngo_app/CustomLibraries/TextDrawable/color_generator.dart';
import 'package:ngo_app/Elements/CommonApiErrorWidget.dart';
import 'package:ngo_app/Elements/CommonApiLoader.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Elements/EachListItemWidget.dart';
import 'package:ngo_app/Elements/PainationLoader.dart';
import 'package:ngo_app/Interfaces/LoadMoreListener.dart';
import 'package:ngo_app/Interfaces/RefreshPageListener.dart';
import 'package:ngo_app/Screens/Dashboard/Home.dart';
import 'package:ngo_app/Screens/Dashboard/ViewAllScreen.dart';
import 'package:ngo_app/Screens/DetailPages/ItemDetailScreen.dart';
import 'package:ngo_app/ServiceManager/ApiResponse.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

class MyDocumentsScreen extends StatefulWidget {
  @override
  _MyDocumentsScreenState createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen>
    with LoadMoreListener, RefreshPageListener,  TickerProviderStateMixin, ImagePickerListener  {
  bool isLoadingMore = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _documentName = new TextEditingController();

  String _imageUrl = "";
  ImagePickerHandler imagePicker;
  AnimationController _controller;
  var subscriptionId;

  @override
  File _image;
  void initState() {
      super.initState();
      _controller = new AnimationController(
        duration: const Duration(milliseconds: 500),

        vsync: this,
      );
      imagePicker = new ImagePickerHandler(this,_controller);
      imagePicker.init();
      // initFields();
  }


  @override
  void dispose() {
    _controller.dispose();
    _documentName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "My Documents",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: Container(
              color: Colors.transparent,
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  _buildUserWidget(),
                    _uploadDocumentWidget(),
                    Visibility(
                      child: PaginationLoader(),
                      visible: isLoadingMore ? true : false,
                    ),
                  ],
                ),
              )),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CommonWidgets().showHelpDesk(),
          ),
        ),
      ),
    );
  }

  void _errorWidgetFunction() {
    // if (_commentsBloc != null) _commentsBloc.getAllComments(false, null);
  Container(
    child: Text("Hai"),
  );
  }


  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  @override
  refresh(bool isLoading) {
    if (mounted) {
      setState(() {
        isLoadingMore = isLoading;
      });
      print(isLoadingMore);
    }
  }

  _buildMessageSection() {
    return Container(
      alignment: FractionalOffset.center,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          color: Color(colorCoderRedBg),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: FractionalOffset.center,
            child: Text(
              "Want to be the cool kind on the block?",
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            alignment: FractionalOffset.center,
            child: Text(
              "Check out our latest fundraisers",
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.0),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              primary: Colors.white,
              elevation: 0.0,
              padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
              side: BorderSide(
                width: 2.0,
                color: Colors.transparent,
              ),
            ),
            onPressed: () {
              Get.offAll(() => DashboardScreen(
                fragmentToShow: 1,
              ));
            },
            child: Text(
              "Browse fundraisers",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(colorCoderRedBg),
                  fontSize: 14,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  _buildRecommendedSection() {
    if (LoginModel().relatedItemsList != null) {
      if (LoginModel().relatedItemsList.length > 0) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: FractionalOffset.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      alignment: FractionalOffset.centerLeft,
                      child: Text(
                        "Related",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(colorCodeBlack),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    ),
                    flex: 1,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        primary: Colors.transparent,
                        elevation: 0.0,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      onPressed: () {
                        CommonMethods().clearFilters();
                        Get.to(() => ViewAllScreen());
                      },
                      child: Text("View All",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 10.0,
                              color: Color(colorCoderRedBg),
                              fontWeight: FontWeight.w500))),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * .45,
                alignment: FractionalOffset.centerLeft,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: LoginModel().relatedItemsList.length,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    itemBuilder: (BuildContext ctx, int index) {
                      return EachListItemWidget(
                          _passedRecommendedFunction,
                          index,
                          ScrollType.Horizontal,
                          LoginModel().relatedItemsList[index],
                          LoginModel().relatedItemsImageBase,
                          LoginModel().relatedItemsWebBaseUrl);
                    }),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  void _passedRecommendedFunction(int itemId) async {
    print("Clicked on : $itemId");
    Map<String, bool> data = await Get.to(() => ItemDetailScreen(itemId));
    if (mounted && data != null) {
      if (data.containsKey("isFundraiserWithdrawn")) {
        if (data["isFundraiserWithdrawn"]) {
          // if (_myDonationsBloc != null) {
          //   _myDonationsBloc.getItems(false);
          // }
        }
      }
    }
  }
  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        this._image = _image;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to set image");
    }
  }
  @override
  void refreshPage() {
    if (mounted) {
      setState(() {
        print("${LoginModel().relatedItemsList.length}");
        print("PageRefreshed");
      });
    }
  }
  Widget _uploadDocumentWidget() {
    var _blankFocusNode = new FocusNode();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(_blankFocusNode);
      },
      child: Container(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              Center(
                child: Text(
                  "Upload Documents",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * .03),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  "Document Name",
                  style: TextStyle(color: Color(colorCodeBlack), fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                child: CommonTextFormField(
                    hintText: "Document Name",
                    maxLinesReceived: 1,
                    maxLengthReceived: 150,
                    controller: _documentName,
                    textColorReceived: Color(colorCodeBlack),
                    fillColorReceived: Colors.black12,
                    hintColorReceived: Colors.black87,
                    borderColorReceived: Color(colorCoderBorderWhite),
                    onChanged: (val) => _documentName = val,
                    validator: CommonMethods().nameValidator),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * .01),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  "Document Image",
                  style: TextStyle(color: Color(colorCodeBlack), fontWeight: FontWeight.w600),
                ),
              ),
              _buildImageSection(),
              Container(
                height: 50.0,
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: CommonButton(
                    buttonText: "Upload",
                    bgColorReceived: Color(colorCoderRedBg),
                    borderColorReceived: Color(colorCoderRedBg),
                    textColorReceived: Color(colorCodeWhite),
                    buttonHandler:_nextBtnClickFunction),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _nextBtnClickFunction() {
    print("_clearBtnClickFunction clicked");
      if (_formKey.currentState.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());

        // if (_image != null) {
        //   // LoginModel().userDetails["pancard_image"] = _image;
        // }
        // // LoginModel().startFundraiserMap["patient_name"] = _documentName.text.trim();
        Fluttertoast.showToast(msg: "SuccessFully Uploaded");
        // Get.to(() => _image);
      } else {
        Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
        return;
    }

  }
  _showdocumentsectin(){
    return  StreamBuilder(
        builder: (context, snapshot) {
          // stream: _profileBlocUser.userRecordStream,
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return SizedBox(
                  child: CommonApiLoader(),
                );
              case Status.COMPLETED:
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 2,
                    itemBuilder:
                        (BuildContext context, int index) {
                      return Card(
                        color: Colors.grey[200],
                        margin: EdgeInsets.only(top: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                               _documentName.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() =>
                                    Image(image: FileImage(File(_image.path)),),);
                                    // Image.asset(
                                    //   "$_image",fit: BoxFit.cover,
                                    //   ),),
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fitWidth,
                                    imageUrl: _imageUrl,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                        margin: EdgeInsets.all(5),
                                        child: Image(
                                          image: AssetImage('assets/images/ic_404_error.png'),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              case Status.ERROR:
                return CommonApiErrorWidget(
                    snapshot.data.message,
                    _errorWidgetFunction);
            }
          }
          return SizedBox(
            height: 30,
            child: CommonApiLoader(),
          );
        });

  }

  _buildImageSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 200,
      color: Colors.transparent,
      child: Container(
        height: 180.0,
        width: double.infinity,
        child: Stack(children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: new BoxDecoration(
              color: Colors.black12,
              // color: Colors.transparent,
              border: Border.all(
                color:  Color(colorCoderBorderWhite),
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
              child: SizedBox.expand(
                child: showImage(),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              child: InkWell(
                child: Image.asset(
                  ('assets/images/ic_camera.png'),
                  height: 45,
                  width: 45,
                ),
                onTap: () {
                  imagePicker.showDialog(context);
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget showImage() {
    if (LoginModel().isFundraiserEditMode) {
      return Center(
        child: _image == null
            ? Container(
          color: Colors.black12,
          child: CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            imageUrl: _imageUrl,
            placeholder: (context, url) => Center(
              child: RoundedLoader(),
            ),
            errorWidget: (context, url, error) => Container(
              child: Image.asset(
                ('assets/images/no_image.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          padding: EdgeInsets.all(0),
        )
            : Container(
          height: 180.0,
          width: double.infinity,
          child: Image.file(_image, fit: BoxFit.fill, errorBuilder:
              (BuildContext context, Object exception,
              StackTrace stackTrace) {
            return Container(
              child: Image.asset(
                ('assets/images/no_image.png'),
                fit: BoxFit.fill,
              ),
            );
          }),
          decoration: BoxDecoration(
            color: Colors.cyan[100],
            borderRadius:
            new BorderRadius.all(const Radius.circular(80.0)),
            image: new DecorationImage(
                image: new AssetImage('assets/images/no_image.png'),
                fit: BoxFit.cover),
          ),
        ),
      );
    } else {
      return Center(
        child: _image == null
            ? Container(
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image(
                  image: AssetImage('assets/images/no_image.png'),
                  height: double.infinity,
                  width: double.infinity,
                ),
                flex: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(5),
        )
            : Container(
          height: 190.0,
          width: double.infinity,
          child: Image.file(_image, fit: BoxFit.fill, errorBuilder:
              (BuildContext context, Object exception,
              StackTrace stackTrace) {
            return Container(
              child: Image.asset(
                ('assets/images/no_image.png'),
                fit: BoxFit.fill,
              ),
            );
          }),
          decoration: BoxDecoration(
            color: Colors.cyan[100],
            borderRadius:
            new BorderRadius.all(const Radius.circular(80.0)),
            image: new DecorationImage(
                image: new AssetImage('assets/images/no_image.png'),
                fit: BoxFit.cover),
          ),
        ),
      );
    }
  }

  @override

  _buildUserWidget() {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildMessageSection(),
              Visibility(
                child: _buildRecommendedSection(),
                visible: isLoadingMore ? false : true,
              ),
              Visibility(
                child: SizedBox(
                  height: 15,
                ),
                visible: isLoadingMore ? false : true,
              ),
            ],
          ),
        );
      }

    }

