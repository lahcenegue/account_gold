class AddInvoiceModel {
  List<dynamic>? alltype;
  List<Allacounts>? allacounts;

  AddInvoiceModel({this.alltype, this.allacounts});

  AddInvoiceModel.fromJson(Map<String, dynamic> json) {
    if (json['alltype'] != null) {
      alltype = json['alltype'];
    }
    if (json['allacounts'] != null) {
      allacounts = <Allacounts>[];
      json['allacounts'].forEach((v) {allacounts!.add(Allacounts.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (alltype != null) {
      data['alltype'] = alltype!.map((v) => v.toList());
    }
    if (allacounts != null) {
      data['allacounts'] = allacounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Allacounts {
  String? name;
  String? balance;
  String? id;

  Allacounts({this.name, this.balance, this.id});

  Allacounts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    balance = json['balance'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['balance'] = this.balance;
    data['id'] = this.id;
    return data;
  }
}