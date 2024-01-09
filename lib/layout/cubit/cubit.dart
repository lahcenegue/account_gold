import 'dart:convert';
import 'dart:io';

import 'package:account_gold/config/routes/app_routes.dart';
import 'package:account_gold/core/network/dio_helper.dart';
import 'package:account_gold/core/network/end_points.dart';
import 'package:account_gold/core/utils/cache_helper.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/data/add_invoice_model.dart';
import 'package:account_gold/data/company_model.dart';
import 'package:account_gold/data/files_model.dart';
import 'package:account_gold/data/group_model.dart';
import 'package:account_gold/data/history_model.dart';
import 'package:account_gold/data/home_data_model.dart';
import 'package:account_gold/data/invoice_model.dart';
import 'package:account_gold/data/payment_model.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  HomeDataModel? homeDataModel;

  void getHomeData({required BuildContext context}) {
    emit(HomeDataLoading());
    DioHelper.getData(
            url: EndPoints.index,
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print(value.data.toString());

      if (value.data['send'] == "ok") {
        homeDataModel = HomeDataModel.fromJson(value.data);

        emit(HomeDataSuccess());
      } else if (value.data['msg'] == "errdor" ||
          value.data['login'] == "out") {
        Constants.showToast(
            msg: value.data['massage'], color: Colors.redAccent);
        Constants.signOut(context);

        emit(HomeDataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      Constants.signOut(context);
      emit(HomeDataError());
    });
  }

  CompanyModel? companyModel;
  void getCompanyData({required String url, String? id}) {
    emit(CompanyDataLoading());
    print("${EndPoints.company}$url/$id");
    DioHelper.getData(
            url: id != null
                ? "${EndPoints.company}$url/$id"
                : "${EndPoints.company}$url",
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print(value.data.toString());

      if (value.data['send'] == "ok") {
        companyModel = CompanyModel.fromJson(value.data);

        emit(CompanyDataSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(CompanyDataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(CompanyDataError());
    });
  }

  InvoiceModel? invoiceModel;
  void getInvoiceData({required String id}) {
    emit(InvoiceDataLoading());
    DioHelper.getData(
            url: EndPoints.show + id,
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print(value.data.toString());

      if (value.data['balance'] != null) {
        invoiceModel = InvoiceModel.fromJson(value.data);

        emit(InvoiceDataSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(InvoiceDataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(InvoiceDataError());
    });
  }

  void getInvoiceDataSearch({required String id, required String search}) {
    emit(InvoiceDataLoading());
    DioHelper.getData(url: EndPoints.show + id, query: {
      "token": CacheHelper.getData(key: PrefKeys.token),
      "search": search
    }).then((value) {
      print(value.data.toString());

      if (value.data['balance'] != null) {
        invoiceModel = InvoiceModel.fromJson(value.data);

        emit(InvoiceDataSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(InvoiceDataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(InvoiceDataError());
    });
  }

  GroupModel? groupModel;
  void getGroupData({required String page, required String url}) {
    emit(GroupDataLoading());
    DioHelper.getData(
            url: "${EndPoints.api}$page/$url",
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print(value.data.toString());

      if (value.data['send'] == "ok") {
        groupModel = GroupModel.fromJson(value.data);

        emit(GroupDataSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(GroupDataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(GroupDataError());
    });
  }

  AddInvoiceModel? addInvoiceModel;
  void getInvoiceAddData({required String url, String? type}) {
    emit(AddInvoiceDataLoading());
    DioHelper.getData(
            url: "${EndPoints.api}/$url/$type",
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print(value.data.toString());

      if (value.statusCode == 200) {
        addInvoiceModel = AddInvoiceModel.fromJson(value.data);

        emit(AddInvoiceDataSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(AddInvoiceDataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(AddInvoiceDataError());
    });
  }

  List<String>? invoice;
  List<String>? invoiceEn;
  List<dynamic>? allAccounts;
  List<String>? allAccountsName;
  List<dynamic>? allAccountsSub;
  String? select1;
  String? select2;
  String? buttonAdd;

  void getInvoiceAdd2Data(
      {required String url, required String id, required String type}) {
    print("typeeeeeeeee   " + type);
    emit(AddInvoice2DataLoading());
    DioHelper.getData(
            url: "${EndPoints.api}$url/$id/$type",
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print(value.data.toString());

      if (value.statusCode == 200) {
        invoice = (value.data['payment_by'] as List)
            .map((e) => e[1] as String)
            .toList();
        invoiceEn = (value.data['payment_by'] as List)
            .map((e) => e[0] as String)
            .toList();
        allAccounts = value.data['allacounts'];
        select1 = value.data['titleselect1'];
        select2 = value.data['titleselect2'];
        allAccountsName =
            allAccounts!.map((e) => e['name']!.toString()).toList();

        emit(AddInvoice2DataSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(AddInvoice2DataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(AddInvoice2DataError());
    });
  }

  void emitState() {
    emit(NewListCompleted());
  }

  final ImagePicker picker =
      ImagePicker(); //////////////////////////////////////////
  File? pickedImage;
  var image;
  void uploadImg(bool camera) async {
    image = await picker.pickImage(
      //source: camera ? ImageSource.camera : ImageSource.gallery,
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 800,
    );
    if (image != null) {
      pickedImage = File(image.path);
      emit(
        GetImageSuccess(),
      );
    } else {
      emit(
        GetImageError(),
      );
    }
  }

  void addInvoice({
    required String paymentType,
    required String select1,
    required String select2,
    required String description,
    required String amount,
    required String type,
    required String id,
    required String startSay,
  }) {
    emit(AddNewInvoiceLoading());

    String? imageString;
    FormData formData;
    if (pickedImage != null) {
      List<int> imageBytes = File(image.path).readAsBytesSync();
      imageString = base64Encode(imageBytes);
      formData = FormData.fromMap({
        'payment_type': paymentType,
        'titleselect1': select1,
        'titleselect2': select2,
        'description': description,
        'startsay': startSay,
        "amount": amount,
        'image': imageString
      });
    } else {
      formData = FormData.fromMap({
        'payment_type': paymentType,
        'titleselect1': select1,
        'titleselect2': select2,
        'description': description,
        'startsay': startSay,
        "amount": amount,
        'image': imageString ?? ""
      });
    }

    DioHelper.postData(
            url: "${EndPoints.api}add3/$id/$type",
            data: formData,
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print('heeeereeeeeeeere0' + value.data.toString());

      if (value.data['msg'] == "ok") {
        emit(AddNewInvoiceSuccess(
            msg: value.data['msg'], massage: value.data['massage']));
      } else if (value.data['msg'] == "error") {
        Constants.showToast(
            msg: value.data['massage'], color: Colors.redAccent);
        emit(AddNewInvoiceError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(AddNewInvoiceError());
    });
  }

  List<AllHistoryPayment> historyModel = [];
  List<AllPayment> listPaymentModel = [];
  PaymentModel? paymentModel;
  int index = 1;

  void getHistoryData({required String page, required String url}) {
    emit(HistoryDataLoading());

    DioHelper.getData(url: "${EndPoints.api}/$page/$url/4", query: {
      "token": CacheHelper.getData(key: PrefKeys.token),
    }).then((value) {
      print(value.data.toString());

      if (value.data['msg'] == "ok") {
        value.data['all'].forEach((v) {
          historyModel.add(AllHistoryPayment.fromJson(v));
        });

        emit(HistoryDataSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(HistoryDataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(HistoryDataError());
    });
  }

  bool thereIsNoData = false;

  void getPaymentData({required String page, required String url}) {
    int newIndex = index++;

    if (thereIsNoData) {
      Constants.showToast(msg: 'لا يوجد بيانات جديدة');
    } else {
      DioHelper.getData(
          url: newIndex == 1
              ? "${EndPoints.api}/$page/$url"
              : "${EndPoints.api}/$page/$url/$newIndex",
          query: {
            "token": CacheHelper.getData(key: PrefKeys.token),
          }).then((value) {
        print(value.data.toString());

        if (value.data['msg'] == "ok") {
          if (value.data['all'].isEmpty) {
            thereIsNoData = true;
          }
          paymentModel = PaymentModel.fromJson(value.data);
          for (var element in paymentModel!.all!) {
            listPaymentModel.add(element);
          }

          emit(PaymentDataSuccess());
        } else if (value.data['msg'] == "errdor") {
          Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
          emit(PaymentDataError());
        }
      }).catchError((onError) {
        print(onError.toString());
        emit(PaymentDataError());
      });
    }
  }

  void getPaymentSearchData({required String url, required String search}) {
    emit(PaymentSearchDataLoading());
    print(url);
    DioHelper.getData(url: "${EndPoints.api}/searchpay/$url", query: {
      "token": CacheHelper.getData(key: PrefKeys.token),
      "search": search,
    }).then((value) {
      listPaymentModel.clear();
      print(value.data.toString());

      if (value.data['msg'] == "ok") {
        paymentModel = PaymentModel.fromJson(value.data);
        for (var element in paymentModel!.all!) {
          listPaymentModel.add(element);
        }
        emit(PaymentSearchDataSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(PaymentSearchDataError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(PaymentSearchDataError());
    });
  }

  void addPayment({
    required String name,
    required String mobile,
    required String amount,
    required String description,
  }) {
    emit(AddPaymentLoading());

    FormData formData = FormData.fromMap({
      'name': name,
      'amount': amount,
      'mobile': mobile,
      'comment': description,
    });

    DioHelper.postData(
            url: "${EndPoints.api}addpay",
            data: formData,
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print('heeeereeeeeeeere0' + value.data.toString());

      if (value.data['msg'] == "ok") {
        emit(AddPaymentSuccess(
          msg: value.data['msg'],
        ));
      } else if (value.data['msg'] == "error") {
        Constants.showToast(
            msg: value.data['massage'], color: Colors.redAccent);
        emit(AddPaymentError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(AddPaymentError());
    });
  }

  int fIndex = 1;
  bool thereIsNoFiles = false;
  FilesModel? filesModel;
  List<AllFiles> listFilesModel = [];
  List<Allcat> allcat = [];

  void getFilesData(
      {required String page,
      required String url,
      required String id,
      required String subId,
      required int number}) {
    int filesIndex = fIndex++;

    if (thereIsNoFiles) {
      Constants.showToast(msg: 'لا يوجد بيانات جديدة');
      thereIsNoData = false;
    } else {
      DioHelper.getData(
          url: number < 1
              ? "${EndPoints.api}/$page/$filesIndex/$id"
              : "${EndPoints.api}/$page/$filesIndex/$id/$subId",
          query: {
            "token": CacheHelper.getData(key: PrefKeys.token),
          }).then((value) {
        print(value.data.toString());
        if (value.data['msg'] == "ok") {
          if (value.data['all'].isEmpty) {
            thereIsNoFiles = true;
            emit(PaymentDataSuccess());
          } else {
            if (value.data['allcat'] != null &&
                filesIndex <= 1 &&
                number <= 1) {
              allcat = <Allcat>[];
              value.data['allcat'].forEach((v) {
                allcat.add(Allcat.fromJson(v));
              });
            }

            filesModel = FilesModel.fromJson(value.data);
            for (var element in filesModel!.all!) {
              listFilesModel.add(element);
            }
            emit(PaymentDataSuccess());
          }
        } else if (value.data['msg'] == "errdor") {
          Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
          emit(PaymentDataError());
        }
      }).catchError((onError) {
        print(onError.toString());
        emit(PaymentDataError());
      });
    }
  }

  void getSearchFilesData({required String page, required String value}) {
    DioHelper.getData(url: "${EndPoints.api}/$page/1", query: {
      "token": CacheHelper.getData(key: PrefKeys.token),
      "search": value
    }).then((value) {
      print(value.data.toString());
      listFilesModel.clear();
      if (value.data['msg'] == "ok") {
        filesModel = FilesModel.fromJson(value.data);
        for (var element in filesModel!.all!) {
          listFilesModel.add(element);
        }

        emit(SearchFileSuccess());
      } else if (value.data['msg'] == "errdor") {
        Constants.showToast(msg: "حدث خطأ ما", color: Colors.redAccent);
        emit(SearchFileError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(SearchFileError());
    });
  }

  void emitNewState() {
    emit(NewUrlSuccess());
  }

  void companyAdd({
    required String name,
    required String phone,
    required String desc,
    String? id,
    required String type,
  }) {
    emit(CompanyAddLoading());

    FormData formData = FormData.fromMap({
      'name': name,
      'mobile': phone,
      'comment': desc,
    });

    DioHelper.postData(
            url: "${EndPoints.api}companyadd/$type/${id ?? ""}",
            data: formData,
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print('heeeereeeeeeeere0  ' + value.data.toString());

      if (value.data['msg'] == "ok") {
        emit(CompanyAddSuccess(
            msg: value.data['msg'].toString(),
            massage: value.data['massage'].toString()));
      } else if (value.data['msg'] == "error") {
        Constants.showToast(
            msg: value.data['massage'], color: Colors.redAccent);
        emit(CompanyAddError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(CompanyAddError());
    });
  }

  void groupAdd({
    required String title,
    required String desc,
    required String type,
  }) {
    emit(GroupAddLoading());

    FormData formData = FormData.fromMap({
      'title': title,
      'comment': desc,
    });

    DioHelper.postData(
            url: "${EndPoints.api}groupadd/$type",
            data: formData,
            query: {"token": CacheHelper.getData(key: PrefKeys.token)})
        .then((value) {
      print('heeeereeeeeeeere0  ' + value.data.toString());

      if (value.data['msg'] == "ok") {
        emit(GroupAddSuccess(
            msg: value.data['msg'].toString(),
            massage: value.data['massage'].toString()));
      } else if (value.data['msg'] == "error") {
        Constants.showToast(
            msg: value.data['massage'], color: Colors.redAccent);
        emit(GroupAddError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(GroupAddError());
    });
  }

  bool internet = true;
  Future<void> checkConn() async {
    internet = await InternetConnection().hasInternetAccess;
    final listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          internet = true;
          emit(InternetChange());
          break;
        case InternetStatus.disconnected:
          internet = false;
          emit(InternetChange());
          break;
      }
    });

    await Future.delayed(const Duration(minutes: 4));
    await listener.cancel();
  }
}
