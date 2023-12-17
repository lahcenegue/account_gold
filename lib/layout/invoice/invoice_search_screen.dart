import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/core/widgets/text_widget.dart';
import 'package:account_gold/data/invoice_model.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:account_gold/layout/invoice/invoice_details_screen.dart';
import 'package:account_gold/layout/invoice/invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceSearchScreen extends StatelessWidget {
  final String id;
   InvoiceSearchScreen({Key? key, required this.id}) : super(key: key);

  var search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = AppCubit.get(context);

          return WillPopScope(
            onWillPop: ()async{
              cubit.invoiceModel = null;
              cubit.getInvoiceData(id: id);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  const SizedBox(width: 50,),
                  Expanded(
                      child: DefaultFormField(
                        onChanged: (String value){
                          if(search.text.length > 2){
                            AppCubit.get(context).getInvoiceDataSearch(id: id, search: value);
                          }
                        },
                        style: TextStyle(color: AppColors.primary),
                        controller: search,
                        decoration:  InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          hintStyle: TextStyle(color: AppColors.text, fontSize: 16),
                          labelText: 'بحث',
                          labelStyle: const TextStyle(color: Colors.grey),

                        ),
                      )),
                  IconButton(
                      onPressed: (){
                        cubit.invoiceModel = null;
                        cubit.getInvoiceData(id: id);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear, size: 28,)),

                ],
                elevation: 0.0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: AppColors.primary),
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30,),
                    cubit.invoiceModel?.allInvoice != null && cubit.invoiceModel!.allInvoice!.isNotEmpty ? Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index)=> invoiceItem(cubit.invoiceModel!.allInvoice![index], context),
                          separatorBuilder: (context, index)=> const SizedBox(height: 15,),
                          itemCount: cubit.invoiceModel!.allInvoice!.length),
                    ) : search.text.isEmpty ? const Center(child:  Text("ابحث في الفواتير")) : const Center(child:  Text("لا توجد فواتير"))
                  ],
                ),
              )
            ),
          );
    }
    );
  }

  Widget invoiceItem(AllInvoice model, BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> InvoiceDetailsScreen(
            balance: model.balance,
            amount: model.amount,
            date: model.date!,
            user: model.user??"",
            type: model.type,
            desc: model.description!,
            payBy: model.paymentBy!,
            payType: model.paymentType!,
            img: model.image!)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25)
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(model.paymentBy!, style: const TextStyle(color: Colors.white),),
                ),
                const SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> InvoiceDetailsScreen(
                        balance: model.balance,
                        amount: model.amount,
                        desc: model.description??'',
                        date: model.date??'',
                        payBy: model.paymentBy!,
                        type: model.type,
                        user: model.user??'',
                        payType: model.paymentType??'',
                        img: model.image??"")));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.payments_outlined, color: Colors.white,),
                  ),
                ),
                const Spacer(),
                Text(model.amount!, style: TextStyle(color: int.parse(model.type!) == 2 ? Colors.green : Colors.redAccent),),
              ],
            ),
            const SizedBox(height: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width/1.6, child: TextWidget(value: model.description!)),
                const SizedBox(height: 15),


              ],
            ),

          ],
        ),
      ),
    );
  }

}
