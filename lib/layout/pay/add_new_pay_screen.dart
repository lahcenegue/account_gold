import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/core/widgets/default_elevated_button.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class AddNewPayScreen extends StatefulWidget {
  const AddNewPayScreen({Key? key}) : super(key: key);

  @override
  State<AddNewPayScreen> createState() => _AddNewPayScreenState();
}

class _AddNewPayScreenState extends State<AddNewPayScreen> {

  var name = TextEditingController();
  var amount = TextEditingController();
  var phone = TextEditingController();
  var purpose = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){
          if(state is AddPaymentSuccess){
            Navigator.of(context).pop();
            Share.share(
                ' مشاركة عملية دفع جديدة\nالاسم: ${name.text} \n المبلغ: ${amount.text}'
            );
          }
        },
        builder: (context, state){

          var cubit = AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: const Text("عملية دفع جديدة"),
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    DefaultFormField(
                      controller: name,
                      validator: 'مطلوب',
                      hint: 'الاسم',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 15,),
                    DefaultFormField(
                      controller: amount,
                      validator: 'مطلوب',
                      keyboard: TextInputType.number,
                      hint: 'المبلغ',
                      prefixIcon: const Icon(Icons.monetization_on),

                    ),
                    const SizedBox(height: 15,),
                    DefaultFormField(
                      controller: phone,
                      validator: 'مطلوب',
                      hint: 'رقم الهاتف',
                      keyboard: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone),

                    ),
                    const SizedBox(height: 15,),
                    DefaultFormField(
                      controller: purpose,
                      hint: 'الهدف',
                      prefixIcon: const Icon(Icons.list_alt),

                    ),
                    const SizedBox(height: 30,),

                    DefaultElevatedButton(
                        onPressed: (){
                          if(formKey.currentState!.validate() ){
                            if(phone.text.length > 7){
                              cubit.addPayment(
                                  name: name.text,
                                  mobile: phone.text,
                                  amount: amount.text,
                                  description: purpose.text);
                            }else{
                              Constants.showToast(msg: "رقم الهاتف يجب الا يقل عن 8 ارقام");
                            }
                          }
                        },
                        child: state is !AddPaymentLoading ? const Text("اضافة", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),) : const Center(child: CircularProgressIndicator(color: Colors.white,),))
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
