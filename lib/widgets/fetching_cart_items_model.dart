class FetchingCartItemsModel {
  bool isSuccess;
  String message;
  Result result;
  Diagnostics diagnostics;

  FetchingCartItemsModel(
      {this.isSuccess, this.message, this.result, this.diagnostics});

  FetchingCartItemsModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    diagnostics = json['diagnostics'] != null
        ? new Diagnostics.fromJson(json['diagnostics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    if (this.diagnostics != null) {
      data['diagnostics'] = this.diagnostics.toJson();
    }
    return data;
  }
}

class Result {
  int productsCount;
  int totalCartAmount;
  Cart cart;

  Result({this.productsCount, this.cart, this.totalCartAmount});

  Result.fromJson(Map<String, dynamic> json) {
    productsCount = json['productsCount'];
    totalCartAmount = json['totalCartAmount'];
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productsCount'] = this.productsCount;
    data['totalCartAmount'] = this.totalCartAmount;
    if (this.cart != null) {
      data['cart'] = this.cart.toJson();
    }
    return data;
  }
}

class Cart {
  String id;
  String createdOn;
  String lastModifiedOn;
  List<ProductList> productList;

  Cart({this.id, this.createdOn, this.lastModifiedOn, this.productList});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    if (json['productList'] != null) {
      productList = new List<ProductList>();
      json['productList'].forEach((v) {
        productList.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.productList != null) {
      data['productList'] = this.productList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  ProductDetail productDetail;
  AdditionalInfo additionalInfo;
  bool isActive;
  String createdOn;
  String paidAmount;
  String lastModifiedOn;

  ProductList(
      {this.productDetail,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.additionalInfo,this.paidAmount});

  ProductList.fromJson(Map<String, dynamic> json) {
    productDetail = json['productDetail'] != null
        ? new ProductDetail.fromJson(json['productDetail'])
        : null;
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    if(json.containsKey("paidAmount")){
      paidAmount=json["paidAmount"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productDetail != null) {
      data['productDetail'] = this.productDetail.toJson();
    }
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['paidAmount'] = this.paidAmount;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    return data;
  }
}

class ProductDetail {
  int id;
  String planName;
  String planSubscriptionFee;
  int packageDuration;

  ProductDetail(
      {this.id, this.planName, this.planSubscriptionFee, this.packageDuration});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['planName'];
    planSubscriptionFee = json['planSubscriptionFee'];
    packageDuration = json['packageDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['planName'] = this.planName;
    data['planSubscriptionFee'] = this.planSubscriptionFee;
    data['packageDuration'] = this.packageDuration;
    return data;
  }
}

class Diagnostics {
  String message;
  ErrorData errorData;
  bool includeErrorDataInResponse;

  Diagnostics({this.message, this.errorData, this.includeErrorDataInResponse});

  Diagnostics.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorData = json['errorData'] != null
        ? new ErrorData.fromJson(json['errorData'])
        : null;
    includeErrorDataInResponse = json['includeErrorDataInResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.errorData != null) {
      data['errorData'] = this.errorData.toJson();
    }
    data['includeErrorDataInResponse'] = this.includeErrorDataInResponse;
    return data;
  }
}

class ErrorData {
  int productsCount;

  ErrorData({this.productsCount});

  ErrorData.fromJson(Map<String, dynamic> json) {
    productsCount = json['productsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productsCount'] = this.productsCount;
    return data;
  }
}

class AdditionalInfo {
  bool isRenewal;
  String tag;
  String remarks;
  String planType;
  bool isMembershipAvail;
  String actualFee;

  AdditionalInfo({this.isRenewal, this.tag});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    isRenewal = json['isRenewal'];
    if (json.containsKey("remarks")) remarks = json['remarks'];
    if (json.containsKey("PlanType")) planType = json['PlanType'];
    if (json.containsKey("actualFee")) actualFee = json['actualFee'];
    if (json.containsKey("isMembershipAvail"))
      isMembershipAvail = json['isMembershipAvail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['remarks'] = this.remarks;
    data['PlanType'] = this.planType;
    data['actualFee'] = this.actualFee;
    data['isRenewal'] = this.isRenewal;
    data['isMembershipAvail'] = this.isMembershipAvail;

    return data;
  }
}
