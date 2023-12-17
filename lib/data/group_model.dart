class GroupModel {
  String? send;
  String? buttonAdd;
  List<AllGroup>? allGroup;

  GroupModel({this.send, this.allGroup});

  GroupModel.fromJson(Map<String, dynamic> json) {
    send = json['send'];
    buttonAdd = json['buttonadd'];
    if (json['all'] != null) {
      allGroup = <AllGroup>[];
      json['all'].forEach((v) {
        allGroup!.add(AllGroup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['send'] = send;
    data['buttonadd'] = buttonAdd;
    if (allGroup != null) {
      data['all'] = allGroup!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllGroup {
  String? name;
  String? type;
  String? id;

  AllGroup({this.name, this.type, this.id});

  AllGroup.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['id'] = id;
    return data;
  }
}