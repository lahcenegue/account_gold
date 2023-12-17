import 'package:account_gold/app.dart';
import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/layout/company/company_screen.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:account_gold/layout/group/add_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupScreen extends StatefulWidget {
  final String page;
  final String url;
  final String name;
  const GroupScreen({Key? key, required this.page, required this.url, required this.name}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getGroupData(page: widget.page, url: widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){

        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.name),
          ),
          floatingActionButton:  cubit.groupModel?.buttonAdd != null && cubit.groupModel!.buttonAdd == "ok" ? FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddGroupScreen(type: widget.url,)));
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white,),) : null,
          body: cubit.groupModel?.allGroup != null ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height/1.3,
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            mainAxisExtent: 80,
                            crossAxisCount: 2),
                        itemBuilder: (context, index)=> itemWidget(name: cubit.groupModel!.allGroup![index].name!, type: cubit.groupModel!.allGroup![index].type!, id: cubit.groupModel!.allGroup![index].id!),
                        itemCount: cubit.groupModel!.allGroup!.length),
                  )
                ],
              ),
            ),
          ) : Center(child: CircularProgressIndicator(color: AppColors.primary,),),
        );
      },
    );
  }

  Widget itemWidget({required String name, required String type, required String id}){
    return InkWell(
      onTap: (){
        AppCubit.get(context).companyModel?.all?.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CompanyScreen(url: type, id: id, name: name, type: type,)));

      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 5,
                  offset: Offset.fromDirection(5)
              )
            ],
            borderRadius: BorderRadius.circular(15)
        ),
        padding: const EdgeInsets.all(15),
        child: Center(child: Text(name, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),)),
      ),
    );
  }
}
