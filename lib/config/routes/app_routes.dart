import 'package:account_gold/core/utils/app_strings.dart';
import 'package:account_gold/core/utils/cache_helper.dart';
import 'package:account_gold/layout/auth/login_screen.dart';
import 'package:account_gold/layout/home/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String initialRoute = '/';
  static const String login = '/login';
  static const String homeScreen = '/homeScreen';
  static const String invoice = '/invoice';
  static const String navBar = '/navBar';
  static const String onBoard = '/onBoard';
  static const String notification = '/notification';
  static const String newAdd = '/newAdd';
  static const String search = '/search';
  static const String support = '/support';
  static const String categoryDetails = '/categoryDetails';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
        if (CacheHelper.getData(key: PrefKeys.token) != null &&
            CacheHelper.getData(key: PrefKeys.token) != "") {
          return MaterialPageRoute(builder: (context) {
            return const HomeScreen();
          });
        } else {
          return MaterialPageRoute(builder: (context) {
            return const LoginScreen();
          });
        }
      case Routes.login:
        return MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        });
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        });

      // case Routes.onBoard:
      //   return MaterialPageRoute(builder: (context) {
      //     return const OnboardScreen();
      //   });
      // case Routes.notification:
      //   return MaterialPageRoute(builder: (context) {
      //     return const NotificationScreen();
      //   });
      // case Routes.newAdd:
      //   return MaterialPageRoute(builder: (context) {
      //     return const NewAddScreen();
      //   });
      // case Routes.search:
      //   return MaterialPageRoute(builder: (context) {
      //     return const SearchScreen();
      //   });
      // case Routes.support:
      //   return MaterialPageRoute(builder: (context) {
      //     return const SupportScreen();
      //   });
      // case Routes.categoryDetails:
      //   return MaterialPageRoute(builder: (context) {
      //     return const CategoryDetailsScreen();
      //   });
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: ((context) => const Scaffold(
              body: Center(
                child: Text(AppStrings.noRouteFound),
              ),
            )));
  }
}
