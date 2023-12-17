class HomeDataModel {
  String? send;
  String? upload;
  List<All>? all;

  HomeDataModel({this.send, this.upload, this.all});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    send = json['send'];
    upload = json['upload'];
    if (json['all'] != null) {
      all = <All>[];
      json['all'].forEach((v) {
        all!.add(All.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['send'] = send;
    data['upload'] = upload;
    if (all != null) {
      data['all'] = all!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class All {
  String? name;
  String? page;
  String? url;

  All({this.name, this.page, this.url});

  All.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    page = json['page'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['page'] = page;
    data['url'] = url;
    return data;
  }
}