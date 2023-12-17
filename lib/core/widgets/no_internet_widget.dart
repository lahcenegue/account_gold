import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/widgets/default_rounded_button.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.signal_wifi_connected_no_internet_4_outlined, size: 100, color: AppColors.primary,),
              const Text('لا يوجد اتصال بالانترنت'),
              const SizedBox(height: 60,),
              DefaultRoundedButton(child: const Text('اعادة المحاولة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), onPressed: (){
                // AppCubit.get(context).checkConn();
              })
            ],
          ),
        ),
      ),
    );
  }
}
