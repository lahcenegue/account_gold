import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/core/widgets/no_internet_widget.dart';
import 'package:account_gold/layout/company/company_screen.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:account_gold/layout/files/file_screen.dart';
import 'package:account_gold/layout/group/group_screen.dart';
import 'package:account_gold/layout/invoice/add_invoice_screen.dart';
import 'package:account_gold/layout/invoice/invoice_screen.dart';
import 'package:account_gold/layout/pay/pay_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    if(AppCubit.get(context).internet){
      AppCubit.get(context).getHomeData(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){

        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text("الحسابات الذهبية", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            leading: IconButton(onPressed: (){}, icon: Icon(Icons.search),),
            actions: [
              IconButton(
                  onPressed: (){
                    Constants.signOut(context);
                  },
                  icon: const Icon(Icons.exit_to_app_outlined))
            ],
          ),
          backgroundColor: Colors.grey.shade50,
          body: cubit.homeDataModel?.send == null ? Center(child: CircularProgressIndicator(color: AppColors.primary,),)
              : cubit.internet ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 25.0,
                          crossAxisSpacing: 20.0,
                          mainAxisExtent: 110,
                          crossAxisCount: 3),
                      itemBuilder: (context, index)=> itemWidget(name: cubit.homeDataModel!.all![index].name!, page: cubit.homeDataModel!.all![index].page!, url: cubit.homeDataModel!.all![index].url!, index: index, id: "", type: cubit.homeDataModel!.all![index].url!),
                      itemCount: cubit.homeDataModel!.all!.length),
                ),
              ],
            ),
          ) : const NoInternetWidget()
        );
      },
    );
  }

  Widget itemWidget({required String page, required String name, required int index, required String url, required String type, required String id, }){
    return InkWell(
      onTap: (){
        if(page == "company"){
          AppCubit.get(context).companyModel?.all?.clear();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CompanyScreen(url: url, name: name, type: type, id: id,)));
        }else if(page == "group"){
          AppCubit.get(context).groupModel?.allGroup?.clear();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> GroupScreen(page: page, url: url, name: name,)));
        }else if(page == "add"){
          AppCubit.get(context).addInvoiceModel?.allacounts?.clear();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddInvoiceScreen(url: url)));
        }else if(page == "show"){
          AppCubit.get(context).invoiceModel?.balance = null;
          Navigator.push(context, MaterialPageRoute(builder: (context)=> InvoiceScreen(id: url, name: name,)));
        }else if(page == "pay"){
          AppCubit.get(context).index = 0;
          Navigator.push(context, MaterialPageRoute(builder: (context)=> PayScreen(page: page, url: url,)));
        }else if(page == "files"){
          AppCubit.get(context).fIndex = 1;
          AppCubit.get(context).filesModel = null;
          Navigator.push(context, MaterialPageRoute(builder: (context)=> FileScreen(title: "الملفات", page: page, number: 0, selectedCat: -1,)));
        }
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: Offset.fromDirection(5)
            )
          ],
          borderRadius: BorderRadius.circular(15)
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              name == "البنوك" ? Icons.account_balance
                  : name == "بطاقات الفيزا"? Icons.credit_card
                  : name == "الكاش"? Icons.money_outlined
                  : name == "الكي نت"? Icons.credit_card
                  : name == "الروابط"? Icons.link_outlined
                  : name == "الشركات"? Icons.home_work
                  : name == "المووردين"? Icons.people
                  : name == "المستفيدين"? Icons.person
                  : name == "العهد"? Icons.card_travel_outlined
                  : name == "روابط الدفع"? Icons.credit_card
                  : name == " الملفات"? Icons.file_copy_outlined : Icons.block,

              color: AppColors.primary, size: 26,),
            const SizedBox(height: 15,),
            Text(name, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),),
          ],
        ),
      ),
    );
}
}
