import 'package:shared_preferences/shared_preferences.dart';

class PrefKeys {
  static String token = 'token';
  static String lang = 'lang';
  static String url = 'url';
  static String password = 'password';
  static String username = 'username';
  static String onBoarding = 'onBoarding';
  static String osUserID = 'osUserID';
  static String uName = 'uName';
  static String rememberMe = 'rememberMe';
}


class CacheHelper{
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }


  static dynamic getData({
    required String key,
  }){
    return sharedPreferences!.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if(value is String) return await sharedPreferences!.setString(key, value);
    if(value is bool) return await sharedPreferences!.setBool(key, value);
    if(value is int) return await sharedPreferences!.setInt(key, value);
    return  await sharedPreferences!.setDouble(key, value);

  }

  static Future<bool> removeData({
    required String key,
  }) async {
    return  await sharedPreferences!.remove(key);
  }

  static Future<void> reloadData() async {
    return  await sharedPreferences!.reload();
  }
}