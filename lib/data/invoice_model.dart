class InvoiceModel {
  dynamic balance;
  dynamic allBillmon1;
  dynamic allBillmon2;
  String? buttonAdd;
  List<AllInvoice>? allInvoice;

  InvoiceModel({this.balance, this.allBillmon1, this.allBillmon2, this.allInvoice, this.buttonAdd});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    allBillmon1 = json['all_billmon1'];
    allBillmon2 = json['all_billmon2'];
    buttonAdd = json['buttonadd'];
    if (json['all'] != null) {
      allInvoice = <AllInvoice>[];
      json['all'].forEach((v) {
        allInvoice!.add(AllInvoice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['all_billmon1'] = allBillmon1;
    data['all_billmon2'] = allBillmon2;
    data['buttonadd'] = buttonAdd;
    if (allInvoice != null) {
      data['all'] = allInvoice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllInvoice {
  dynamic amount;
  dynamic type;
  dynamic balance;
  String? description;
  String? date;
  String? user;
  String? paymentType;
  String? paymentBy;
  String? image;

  AllInvoice(
      {this.amount,
        this.type,
        this.description,
        this.image,
        this.user,
        this.date,
        this.balance,
        this.paymentType,
        this.paymentBy});

  AllInvoice.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    type = json['type'];
    date = json['date'];
    user = json['user'];
    image = json['image'];
    description = json['description'];
    paymentType = json['payment_type'];
    balance = json['balance'];
    paymentBy = json['payment_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['type'] = type;
    data['image'] = image;
    data['date'] = date;
    data['user'] = user;
    data['description'] = description;
    data['payment_type'] = paymentType;
    data['balance'] = balance;
    data['payment_by'] = paymentBy;
    return data;
  }
}