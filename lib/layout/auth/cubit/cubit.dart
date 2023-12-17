import 'package:account_gold/core/network/dio_helper.dart';
import 'package:account_gold/core/network/end_points.dart';
import 'package:account_gold/core/utils/cache_helper.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/layout/auth/cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(InitialState());

  static AuthCubit get(context) => BlocProvider.of(context);


  void login({required String username, required String password, /*required String signalId*/}){
    FormData formData = FormData.fromMap({
      'user': username,
      'password': password
    });

    emit(LoginLoading());

    DioHelper.postData(
        url: "${EndPoints.login}${CacheHelper.getData(key: PrefKeys.osUserID)}",
        data: formData,
    ).then((value) {
      print(value.data.toString());

      if(value.data['msg'] == "ok"){
        CacheHelper.saveData(key: PrefKeys.token, value: value.data['token']);
        CacheHelper.saveData(key: PrefKeys.uName, value: value.data['name']);
        emit(LoginSuccess());
      }else if (value.data['msg'] == "error"){
        Constants.showToast(msg: value.data['massage'], color: Colors.redAccent);
        emit(LoginError());
      }
    }).catchError((onError){
      print(onError.toString());
      emit(LoginError());
    });
  }
  
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());

  }

  void emitNewState(){
    emit(NewUrlSuccess());
  }

}