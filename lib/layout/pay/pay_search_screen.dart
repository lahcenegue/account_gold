import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/data/payment_model.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaySearchScreen extends StatelessWidget {
  final String url;
  final String page;
  PaySearchScreen({Key? key, required this.url, required this.page}) : super(key: key);

  var search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, index){},
      builder: (context, index){

        var cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: ()async{
            cubit.index = 1;
            cubit.listPaymentModel.clear();
            cubit.getPaymentData(page: page, url: url);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: (){
                      cubit.listPaymentModel.clear();
                      cubit.index = 1;
                      cubit.getPaymentData(page: page, url: url);

                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear))
              ],
              title: DefaultFormField(
                onChanged: (String value){
                  AppCubit.get(context).getPaymentSearchData(url: url, search: value,);
                },
                cursorColor: Colors.white,
                controller: search,
                decoration: const  InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                  hintText: "بحث",
                  focusColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white),

                ),
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: cubit.listPaymentModel.isNotEmpty ?  SizedBox(
                height: MediaQuery.of(context).size.height/1.2,
                child: ListView.separated(
                    itemBuilder: (context, index)=> itemWidget(cubit.listPaymentModel[index], context),
                    separatorBuilder: (context, index)=> const SizedBox(height: 15  ,),
                    itemCount: cubit.listPaymentModel.length),
              ) : search.text.isEmpty ? const Center(child: Text("اكتب البحث..."),) : const Center(child: Text("لا يوجد نتائج متطابقة"),),
            ),
          ),
        );
      },
    );
  }

  Widget itemWidget(AllPayment model, BuildContext context){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(model.name!),
              const Spacer(),
              Text(model.amount!, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "الهاتف",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      model.mobile!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "التاريخ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      model.date1!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            ],
          ),
          SizedBox(height: 15,),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(10),
            child:   Text(
              model.comment!,
              style: TextStyle(fontSize: 16),
            ),
          ),

        ],
      ),
    );
  }
}
