import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/core/widgets/default_elevated_button.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddGroupScreen extends StatefulWidget {
  final String type;
  const AddGroupScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {

  var title = TextEditingController();
  var desc = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){
        if(state is GroupAddSuccess){
          if(state.msg == "ok"){
            Constants.showToast(msg: state.massage);
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state){

        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text("اضافة"),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  DefaultFormField(
                    hint: "العنوات",
                    validator: 'مطلوب',
                    controller: title,
                  ),
                  const SizedBox(height: 15,),
                  DefaultFormField(
                    hint: 'الوصف',
                    controller: desc,
                    minLines: 2,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 30,),
                  DefaultElevatedButton(
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          cubit.groupAdd(
                              title: title.text,
                              desc: desc.text,
                              type: widget.type);
                        }
                      },
                      child: state is !GroupAddLoading ? const Text("تاكيد", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),) :
                      const Center(child: CircularProgressIndicator(color: Colors.white,),))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
