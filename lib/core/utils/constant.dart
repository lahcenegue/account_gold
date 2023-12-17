import 'package:account_gold/config/routes/app_routes.dart';
import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/utils/cache_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Constants {
  static void showErrorDialog(
      {required BuildContext context, required String msg}) {
    showDialog(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoAlertDialog(
            title: Text(
              msg,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                child: const Text('Ok'),
              )
            ],
          ),
        ));
  }

  static void showToast(
      {required String msg, Color? color, ToastGravity? gravity}) {
    Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: msg,
        backgroundColor: color ?? AppColors.primary,
        gravity: gravity ?? ToastGravity.BOTTOM);
  }

  static void signOut(context){
    CacheHelper.removeData(key: PrefKeys.token).then((value){
      if(value){
        navigateAndFinish(context, Routes.login);
      }
    });
  }

  static void navigateAndFinish(
      context,
      routeName,
      )=> Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);

  static void navigateTo(
      context,
      routeName,
      )=> Navigator.pushNamed(context, routeName);
  static String baseUrl = "https://electron-accounts.com/beta/";
}
