class CompanyModel {
  String? send;
  String? buttonAdd;
  List<AllCompany>? all;

  CompanyModel({this.send, this.all});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    send = json['send'];
    buttonAdd = json['buttonadd'];
    if (json['all'] != null) {
      all = <AllCompany>[];
      json['all'].forEach((v) {
        all!.add(AllCompany.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['send'] = send;
    data['buttonadd'] = buttonAdd;
    if (all != null) {
      data['all'] = all!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllCompany {
  String? name;
  dynamic balance;
  String? id;

  AllCompany({this.name, this.balance, this.id});

  AllCompany.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    balance = json['balance'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['balance'] = balance;
    data['id'] = id;
    return data;
  }
}