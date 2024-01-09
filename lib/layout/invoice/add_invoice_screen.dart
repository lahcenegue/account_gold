import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:account_gold/layout/invoice/choose_type_and_complete.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddInvoiceScreen extends StatefulWidget {
  final String url;
  final String? type;
  const AddInvoiceScreen({Key? key, required this.url, this.type})
      : super(key: key);

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  @override
  void initState() {
    AppCubit.get(context).getInvoiceAddData(url: widget.url, type: widget.type);
    super.initState();
  }

  int selectedAccount = 0;
  int typeAdd = -1;

  var drop = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              title: const Text("اضافة فاتورة"),
            ),
            body: cubit.addInvoiceModel?.alltype != null
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        AppCubit.get(context).addInvoiceModel?.allacounts !=
                                    null &&
                                AppCubit.get(context)
                                        .addInvoiceModel!
                                        .allacounts!
                                        .length >
                                    1
                            ? CustomDropdown(
                                items: AppCubit.get(context)
                                    .addInvoiceModel!
                                    .allacounts!
                                    .map((e) => e.name!)
                                    .toList(),
                                selectedStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                borderSide:
                                    BorderSide(color: AppColors.primary),
                                hintText: '  اختر الحساب',
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                controller: drop,
                                onChanged: (value) {
                                  // int index = valueList.indexWhere((element) => element == drop.text);
                                  // cubit.noaIndex = index + 1;
                                  // cubit.getRepairList();
                                },
                              )
                            : AppCubit.get(context)
                                        .addInvoiceModel
                                        ?.allacounts !=
                                    null
                                ? itemWidget(
                                    name: cubit
                                        .addInvoiceModel!.allacounts![0].name!,
                                    balance: cubit.addInvoiceModel!
                                        .allacounts![0].balance!,
                                    id: cubit
                                        .addInvoiceModel!.allacounts![0].id!,
                                    index: 0)
                                : const SizedBox(),
                        const SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) => typeWidget(
                              ar: cubit.addInvoiceModel!.alltype![index][1],
                              en: cubit.addInvoiceModel!.alltype![index][0],
                              index: index,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20.0,
                              crossAxisSpacing: 20.0,
                              mainAxisExtent: 90,
                              crossAxisCount: 2,
                            ),
                            itemCount: cubit.addInvoiceModel!.alltype!.length,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ));
      },
    );
  }

  Widget itemWidget(
      {required String name,
      required String balance,
      required String id,
      required int index}) {
    return InkWell(
      onTap: () {},
      child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: 115,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset.fromDirection(5),
                    blurRadius: 5)
              ]),
          padding: const EdgeInsets.all(15),
          child: Text(name)),
    );
  }

  Widget typeWidget(
      {required String ar, required String en, required int index}) {
    return InkWell(
      onTap: () {
        if (selectedAccount >= 0 &&
            AppCubit.get(context).addInvoiceModel!.allacounts!.isNotEmpty) {
          typeAdd = index;
          AppCubit.get(context).pickedImage = null;
          setState(() {});
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseTypeAndComplete(
                    account: AppCubit.get(context)
                        .addInvoiceModel!
                        .allacounts![selectedAccount]
                        .name!,
                    type: AppCubit.get(context)
                        .addInvoiceModel!
                        .alltype![typeAdd],
                    id: AppCubit.get(context)
                        .addInvoiceModel!
                        .allacounts![selectedAccount]
                        .id!),
              ),
            );
          });
        } else {
          Constants.showToast(
              msg: "برجاء اختيار الحساب", color: Colors.redAccent);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: typeAdd == index ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset.fromDirection(5))
            ]),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ar,
              style: TextStyle(
                color: typeAdd == index ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
