class TestPaymentModel {
  String amount;
  Body body;
  Head head;
  String mid;
  String order_id;


  TestPaymentModel({this.amount, this.body, this.head, this.mid, this.order_id});

  factory TestPaymentModel.fromJson(Map<String, dynamic> json) {
    return TestPaymentModel(
      amount: json['amount'],
      body: json['body'] != null ? Body.fromJson(json['body']) : null,
      head: json['head'] != null ? Head.fromJson(json['head']) : null,
      mid: json['mid'],
      order_id: json['order_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['mid'] = this.mid;
    data['order_id'] = this.order_id;
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    if (this.head != null) {
      data['head'] = this.head.toJson();
    }
    return data;
  }
}

class Head {
  String responseTimestamp;
  String signature;
  String version;

  Head({this.responseTimestamp, this.signature, this.version});

  factory Head.fromJson(Map<String, dynamic> json) {
    return Head(
      responseTimestamp: json['responseTimestamp'],
      signature: json['signature'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseTimestamp'] = this.responseTimestamp;
    data['signature'] = this.signature;
    data['version'] = this.version;
    return data;
  }
}

class Body {
  bool authenticated;
  bool isPromoCodeValid;
  ResultInfo resultInfo;
  String txnToken;

  Body({this.authenticated, this.isPromoCodeValid, this.resultInfo, this.txnToken});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      authenticated: json['authenticated'],
      isPromoCodeValid: json['isPromoCodeValid'],
      resultInfo: json['resultInfo'] != null ? ResultInfo.fromJson(json['resultInfo']) : null,
      txnToken: json['txnToken'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authenticated'] = this.authenticated;
    data['isPromoCodeValid'] = this.isPromoCodeValid;
    data['txnToken'] = this.txnToken;
    if (this.resultInfo != null) {
      data['resultInfo'] = this.resultInfo.toJson();
    }
    return data;
  }
}

class ResultInfo {
  String resultCode;
  String resultMsg;
  String resultStatus;

  ResultInfo({this.resultCode, this.resultMsg, this.resultStatus});

  factory ResultInfo.fromJson(Map<String, dynamic> json) {
    return ResultInfo(
      resultCode: json['resultCode'],
      resultMsg: json['resultMsg'],
      resultStatus: json['resultStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCode'] = this.resultCode;
    data['resultMsg'] = this.resultMsg;
    data['resultStatus'] = this.resultStatus;
    return data;
  }

}
