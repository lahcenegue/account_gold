import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/core/widgets/text_widget.dart';
import 'package:account_gold/data/invoice_model.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:account_gold/layout/invoice/add_invoice_screen.dart';
import 'package:account_gold/layout/invoice/invoice_details_screen.dart';
import 'package:account_gold/layout/invoice/invoice_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceScreen extends StatefulWidget {
  final String id;
  final String? type;
  final String? name;
  const InvoiceScreen({Key? key, required this.id, this.type, this.name}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getInvoiceData(id: widget.id);
  }

  bool search = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){

        var cubit = AppCubit.get(context);

        return  Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: (){
                    cubit.invoiceModel = null;
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> InvoiceSearchScreen(id: widget.id)));
                  },
                  icon: Icon(Icons.search, size: 28,)),

            ],
            title: Text(widget.name??"", style: TextStyle(color: AppColors.primary),),
            elevation: 0.0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: AppColors.primary),
          ),
          floatingActionButton: cubit.invoiceModel?.buttonAdd !=null && cubit.invoiceModel!.buttonAdd == "ok"?  FloatingActionButton(
              onPressed: (){
                cubit.addInvoiceModel?.allacounts = null;
                cubit.addInvoiceModel?.alltype = null;
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddInvoiceScreen(url: 'add/${widget.id}', type: widget.type,)));
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white,)) : null,
          body: cubit.invoiceModel?.balance != null ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("الرصيد", style: TextStyle(color: Colors.white,)),
                        const SizedBox(height: 10,),
                        Center(child: Text(cubit.invoiceModel!.balance!.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: Offset.fromDirection(5)
                              )
                            ]
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("دائن الشهر", style: TextStyle(color: AppColors.primary, fontSize: 14)),
                            const SizedBox(height: 10,),
                            Center(child: SizedBox(width: cubit.invoiceModel!.allBillmon1!.toString().length > 20 ? MediaQuery.of(context).size.width/3 : null, child: Text(cubit.invoiceModel!.allBillmon1!.toString(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18),))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width/2.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset.fromDirection(5)
                            )
                          ]
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("مدين  الشهر", style: TextStyle(color: AppColors.primary, fontSize: 14)),
                            const SizedBox(height: 10,),
                            Center(child: SizedBox(width: cubit.invoiceModel!.allBillmon2!.toString().length > 20 ? MediaQuery.of(context).size.width/3 : null, child: Text(cubit.invoiceModel!.allBillmon2!.toString(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18),))),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  cubit.invoiceModel?.allInvoice != null ? ListView.separated(
                    shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index)=> invoiceItem(cubit.invoiceModel!.allInvoice![index]),
                      separatorBuilder: (context, index)=> const SizedBox(height: 15,),
                      itemCount: cubit.invoiceModel!.allInvoice!.length) : search ? const Text("لا توجد نتائج مطابقة"): const Text("لا توجد فواتير")
                ],
              ),
            ),
          ) : Center(child: CircularProgressIndicator(color: AppColors.primary,),),
        );
      },
    );
  }

  Widget invoiceItem(AllInvoice model){
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
          borderRadius: BorderRadius.circular(15)
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(model.paymentBy!, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),),
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
