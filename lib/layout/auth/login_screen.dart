import 'package:account_gold/config/routes/app_routes.dart';
import 'package:account_gold/core/network/dio_helper.dart';
import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/utils/cache_helper.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/core/widgets/default_elevated_button.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/layout/auth/cubit/cubit.dart';
import 'package:account_gold/layout/auth/cubit/states.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var username = TextEditingController();
  var password = TextEditingController();
  var url = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool editUrl = false;
  bool rememberMe = false;

  @override
  void initState() {
    if(CacheHelper.getData(key: PrefKeys.rememberMe) != null && CacheHelper.getData(key: PrefKeys.rememberMe) == true){
      rememberMe = true;
      username.text = CacheHelper.getData(key: PrefKeys.username);
      password.text = CacheHelper.getData(key: PrefKeys.password);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state){
          if(state is LoginSuccess){
            Constants.navigateAndFinish(context, Routes.homeScreen);
          }
        },
        builder: (context, state){

          var cubit = AuthCubit.get(context);

          return Scaffold(
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: (){
                            editUrl = false;

                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    SimpleDialog(
                                        backgroundColor:
                                        Colors.white,
                                        contentPadding:
                                        const EdgeInsets.all(15),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        children: [
                                          StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState)=> Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'رابط الـ API',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                      AppColors.primary,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                editUrl ? Directionality(
                                                  textDirection: TextDirection.ltr,
                                                  child: DefaultFormField(
                                                    controller: url,
                                                    hint: "url",
                                                    minLines: 2,
                                                    maxLines: 2,
                                                  ),
                                                ) : Text(CacheHelper.getData(key: PrefKeys.url) ?? Constants.baseUrl),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Center(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: DefaultElevatedButton(
                                                            onPressed: () {
                                                              if(url.text.isNotEmpty){
                                                                CacheHelper.saveData(key: PrefKeys.url, value: url.text).then((value) {
                                                                  Constants.showToast(msg: 'تم حفظ الرابط');
                                                                }).then((value) {
                                                                  CacheHelper.reloadData().then((value) {
                                                                    DioHelper.init();
                                                                    Navigator.pop(context);
                                                                  });
                                                                });
                                                              }
                                                            },
                                                            child: const Text(
                                                              'موافق',
                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                            )),
                                                      ),
                                                      const SizedBox(width: 15,),
                                                      Expanded(
                                                        child: TextButton(
                                                            onPressed: () {
                                                              if(CacheHelper.getData(key: PrefKeys.url) != null){
                                                                url.text = CacheHelper.getData(key: PrefKeys.url);
                                                                editUrl = true;
                                                                setState(() {});
                                                                // CacheHelper.saveData(key: PrefKeys.url, value: url.text).then((value) {
                                                                //   Navigator.pop(context);
                                                                //   Constants.showToast(msg: 'تم حفظ الرابط');
                                                                // }).then((value) {
                                                                //   cubit.emitNewState();
                                                                // });
                                                              }else{
                                                                url.text = Constants.baseUrl;
                                                                editUrl = true;
                                                                setState(() {});
                                                              }
                                                            },
                                                            child: Text(
                                                              'تعديل',
                                                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ]));
                          },
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25)
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.link, color: AppColors.primary,),
                                const SizedBox(width: 5,),
                                Text("URL", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("تسجيل الدخول", style: TextStyle(fontSize: 30, color: AppColors.primary, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 40,),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: DefaultFormField(
                            controller: username,
                            validator: '',
                            prefixIcon: Icon(Icons.perm_identity, color: AppColors.primary,),
                            hint: 'اسم المستخدم',),
                        ),
                        const SizedBox(height: 20,),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: DefaultFormField(
                            controller: password,
                            validator: '',
                            keyboard: TextInputType.visiblePassword,
                            isPassword: cubit.isPassword,
                            suffixIcon: IconButton(onPressed: (){
                              cubit.changePasswordVisibility();
                            }, icon: Icon(cubit.suffix, color: AppColors.primary,)),
                            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary,),
                            hint: 'كلمة المرور',
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Checkbox(
                                value: rememberMe,
                                activeColor: AppColors.primary,
                                onChanged: (v){
                                  rememberMe = v!;
                                  CacheHelper.saveData(key: PrefKeys.rememberMe, value: v);
                                  setState(() {});
                                }),
                            Text("تذكرني", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),)
                          ],
                        ),

                        const SizedBox(height: 40,),

                        DefaultElevatedButton(
                          onPressed: (){
                            print(CacheHelper.getData(key: PrefKeys.url));
                            if(formKey.currentState!.validate()){
                              if(rememberMe){
                                CacheHelper.saveData(key: PrefKeys.username, value: username.text);
                                CacheHelper.saveData(key: PrefKeys.password, value: password.text);
                                cubit.login(username: username.text, password: password.text);
                              }else{
                                cubit.login(username: username.text, password: password.text);
                              }
                            }
                          },
                          child: state is LoginLoading ? const Center(child: CircularProgressIndicator(color: Colors.white),) : const Text("تسجيل الدخول", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), )
                      ],
                    ),
                    const Spacer()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
