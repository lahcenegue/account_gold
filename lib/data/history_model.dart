class HistoryModel {
  String? msg;
  List<AllHistoryPayment>? all;

  HistoryModel({this.msg, this.all});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['all'] != null) {
      all = <AllHistoryPayment>[];
      json['all'].forEach((v) {
        all!.add(AllHistoryPayment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (all != null) {
      data['all'] = all!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllHistoryPayment {
  String? id;
  String? name;
  String? mobile;
  String? amount;
  String? md5id;
  String? comment;
  String? show1;
  String? date1;
  String? paymentdate;
  int? sharebutton;

  AllHistoryPayment(
      {this.id,
        this.name,
        this.mobile,
        this.amount,
        this.md5id,
        this.comment,
        this.show1,
        this.date1,
        this.paymentdate,
        this.sharebutton});

  AllHistoryPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    amount = json['amount'];
    md5id = json['md5id'];
    comment = json['comment'];
    show1 = json['show1'];
    date1 = json['date1'];
    paymentdate = json['paymentdate'];
    sharebutton = json['sharebutton'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['amount'] = amount;
    data['md5id'] = md5id;
    data['comment'] = comment;
    data['show1'] = show1;
    data['date1'] = date1;
    data['paymentdate'] = paymentdate;
    data['sharebutton'] = sharebutton;
    return data;
  }
}