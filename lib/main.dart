import 'package:account_gold/app.dart';
import 'package:account_gold/core/network/dio_helper.dart';
import 'package:account_gold/core/utils/cache_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
//  await Firebase.initializeApp();
  await CacheHelper.init();
  await DioHelper.init();
  // await FlutterDownloader.initialize(
  //     debug: true, // optional: set to false to disable printing logs to console (default: true)
  // );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      useFallbackTranslations: true,
      saveLocale: true,
      useOnlyLangCode: true,
      child: const App(),
    ),
  );

  OneSignal.shared.setAppId('8e108e59-b233-4a83-927a-029f36036929');
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  final status = await OneSignal.shared.getDeviceState();
  final String? osUserID = status?.userId;
  print(
      "osUserIDosUserIDosUserIDosUserIDosUserIDosUserIDUserIDosUserIDosUserID" +
          osUserID.toString());
  if (osUserID != null) {
    CacheHelper.saveData(key: PrefKeys.osUserID, value: osUserID);
  }
}
