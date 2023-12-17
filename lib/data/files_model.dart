class FilesModel {
  List<Allcat>? allcat;
  String? msg;
  List<AllFiles>? all;

  FilesModel({this.allcat, this.msg, this.all});

  FilesModel.fromJson(Map<String, dynamic> json) {
    if (json['allcat'] != null) {
      allcat = <Allcat>[];
      json['allcat'].forEach((v) {
        allcat!.add(Allcat.fromJson(v));
      });
    }
    msg = json['msg'];
    if (json['all'] != null) {
      all = <AllFiles>[];
      json['all'].forEach((v) {
        all!.add(AllFiles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (allcat != null) {
      data['allcat'] = allcat!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    if (all != null) {
      data['all'] = all!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Allcat {
  String? id;
  String? name;
  String? page;

  Allcat({this.id, this.name, this.page});

  Allcat.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['page'] = page;
    return data;
  }
}

class AllFiles {
  String? id;
  String? name;
  String? file1;
  String? file2;
  int? type;
  String? daterest;
  String? date;

  AllFiles(
      {this.id,
        this.name,
        this.file1,
        this.file2,
        this.type,
        this.daterest,
        this.date});

  AllFiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    file1 = json['file1'];
    file2 = json['file2'];
    type = json['type'];
    daterest = json['daterest'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['file1'] = file1;
    data['file2'] = file2;
    data['type'] = type;
    data['daterest'] = daterest;
    data['date'] = date;
    return data;
  }
}