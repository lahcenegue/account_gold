import 'package:account_gold/core/utils/cache_helper.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper{
  static Dio? dio;

  static init(){
    dio = Dio(
      BaseOptions(
        baseUrl: CacheHelper.getData(key: PrefKeys.url) ?? Constants.baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type':'application/json',
        }
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {

    return await dio!.get(
      url,
      queryParameters: query,

    );
  }

  static Future<Response> postData({
    required String url,
    FormData? data,
    Map<String, dynamic>? query,

  }) async {
    dio!.options.headers = {
      'Content-Type':'application/json',
    };
    return  dio!.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<dynamic, String>? data,
    Map<String, dynamic>? query,

  }) async {
    dio!.options.headers = {
      'Content-Type':'application/json',

    };
    return  dio!.put(
      url,
      data: data,
      queryParameters: query,
    );
  }

}