import 'package:account_gold/config/routes/app_routes.dart';
import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/core/widgets/default_elevated_button.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ChooseTypeAndComplete extends StatefulWidget {
  final String account;
  final String id;
  final List type;
  const ChooseTypeAndComplete({
    Key? key,
    required this.account,
    required this.type,
    required this.id,
  }) : super(key: key);

  @override
  State<ChooseTypeAndComplete> createState() => _ChooseTypeAndCompleteState();
}

class _ChooseTypeAndCompleteState extends State<ChooseTypeAndComplete> {
  int selectedType = 0;
  var dropType = TextEditingController();
  var allAccounts = TextEditingController();
  var allSub = TextEditingController();
  var price = TextEditingController();
  var description = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    AppCubit.get(context)
        .getInvoiceAdd2Data(url: "add2", id: widget.id, type: widget.type[0]);
  }

  DateTime now = DateTime.now();

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        textDirection: TextDirection.rtl,
        firstDate: DateTime(2023),
        lastDate: DateTime(2028));
    if (picked != null && picked != now) {
      setState(() {
        now = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddNewInvoiceSuccess) {
          if (state.msg == "ok") {
            Constants.showToast(msg: state.massage);
            Constants.navigateAndFinish(context, Routes.homeScreen);
          }
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: () async {
            cubit.invoice = null;
            cubit.allAccountsName = null;
            cubit.allAccountsSub = null;
            if (cubit.invoice == null && cubit.allAccountsName == null) {
              return true;
            }
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              title: Column(
                children: [
                  Text(
                    widget.type[1],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "من حساب: ${widget.account}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w100, fontSize: 14),
                  ),
                ],
              ),
            ),
            body: cubit.invoice != null
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),

                            cubit.allAccountsName != null
                                ? TypeAheadFormField(
                                    suggestionsCallback: (pattern) => cubit
                                        .allAccountsName!
                                        .where((element) =>
                                            element.contains(pattern)),
                                    itemBuilder: (context, element) {
                                      return ListTile(
                                        leading: const Icon(
                                            Icons.supervised_user_circle),
                                        title: Text(element.toString()),
                                      );
                                    },
                                    onSuggestionSelected: (element) {
                                      int index = cubit.allAccountsName!
                                          .indexWhere((e) => e == element);
                                      if (cubit.allAccounts![index]['allsub'] !=
                                          null) {
                                        cubit.allAccountsSub = (cubit
                                                    .allAccounts![index]
                                                ['allsub'] as List)
                                            .map((e) => e['name']! as String)
                                            .toList();
                                        dropType.text = cubit.invoice!.first;
                                        allAccounts.text =
                                            cubit.allAccounts![index]['name'];
                                        if (cubit.allAccountsSub!.isNotEmpty) {
                                          cubit.emitState();
                                        }
                                      }
                                      allAccounts.text = element;
                                    },
                                    getImmediateSuggestions: true,
                                    validator: (data) {
                                      if (data!.isEmpty) {
                                        return 'برجاء ${cubit.select1}';
                                      }
                                      return null;
                                    },
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              labelText: cubit.select1,
                                              contentPadding:
                                                  const EdgeInsets.all(12),
                                              labelStyle: const TextStyle(
                                                color: Colors.black,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.primary)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.primary)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.primary)),
                                            ),
                                            controller: allAccounts),
                                  )
                                : const SizedBox(),
                            // cubit.allAccountsName != null
                            //     ? CustomDropdown(
                            //         items: cubit.allAccountsName,
                            //         selectedStyle: const TextStyle(
                            //             fontWeight: FontWeight.bold),
                            //         borderSide:
                            //             BorderSide(color: AppColors.primary),
                            //         hintText: cubit.select1,
                            //         hintStyle: const TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.black),
                            //         controller: allAccounts,
                            //         onChanged: (value) {
                            //
                            //         },
                            //       )
                            //     : const SizedBox(),
                            const SizedBox(height: 15),

                            // cubit.allAccountsSub != null
                            //     ? CustomDropdown(
                            //         items: cubit.allAccountsSub,
                            //         selectedStyle: const TextStyle(
                            //             fontWeight: FontWeight.bold),
                            //         borderSide:
                            //             BorderSide(color: AppColors.primary),
                            //         hintText: cubit.select2,
                            //         hintStyle: const TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.black),
                            //         controller: allSub,
                            //         onChanged: (value) {
                            //           // int index = valueList.indexWhere((element) => element == drop.text);
                            //           // cubit.noaIndex = index + 1;
                            //           // cubit.getRepairList();
                            //         },
                            //       )
                            //     : const SizedBox(),

                            cubit.allAccountsSub != null
                                ? TypeAheadFormField(
                                    suggestionsCallback: (pattern) =>
                                        cubit.allAccountsSub!.where((element) =>
                                            element!.contains(pattern)),
                                    itemBuilder: (context, element) {
                                      return ListTile(
                                        leading: const Icon(
                                            Icons.supervised_user_circle),
                                        title: Text(element.toString()),
                                      );
                                    },
                                    onSuggestionSelected: (element) {
                                      allSub.text = element;
                                    },
                                    getImmediateSuggestions: true,
                                    validator: (data) {
                                      if (data!.isEmpty) {
                                        return 'برجاء ${cubit.select2}';
                                      }
                                      return null;
                                    },
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              labelText: cubit.select2,
                                              contentPadding:
                                                  const EdgeInsets.all(12),
                                              labelStyle: const TextStyle(
                                                color: Colors.black,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.primary)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.primary)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.primary)),
                                            ),
                                            controller: allSub),
                                  )
                                : const SizedBox(),

                            const SizedBox(
                              height: 15,
                            ),
                            DefaultFormField(
                              hint: "المبلغ",
                              keyboard: TextInputType.number,
                              controller: price,
                              validator: 'برجاء ادخال المبلغ',
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            CustomDropdown(
                              items: cubit.invoice,
                              selectedStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              borderSide: BorderSide(color: AppColors.primary),
                              hintText: '  اختر طريقة الدفع',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              controller: dropType,
                              onChanged: (value) {
                                // int index = valueList.indexWhere((element) => element == drop.text);
                                // cubit.noaIndex = index + 1;
                                // cubit.getRepairList();
                              },
                            ),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 100,
                            //   child: ListView.separated(
                            //       scrollDirection: Axis.horizontal,
                            //         itemBuilder: (context, index)=> itemWidget(ar: cubit.invoice['payment_by'][index][1], en: cubit.invoice['payment_by'][index][0], index: index),
                            //         separatorBuilder: (context, index)=> const SizedBox(width: 5),
                            //         itemCount: cubit.invoice['payment_by'].length),
                            // ),
                            const SizedBox(
                              height: 10,
                            ),
                            DefaultFormField(
                              hint: "الوصف",
                              controller: description,
                              validator: 'برجاء وضع وصف',
                              maxLines: 4,
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            const Text("ارفاق صورة"),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  print('photo');
                                                  cubit.uploadImg(false);
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .photo_size_select_actual,
                                                  color: AppColors.primary,
                                                  size: 50,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  print('cameera');
                                                  cubit.uploadImg(true);
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.camera_alt,
                                                  size: 50,
                                                )),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.all(
                                    cubit.pickedImage != null ? 5 : 30),
                                child: cubit.pickedImage != null
                                    ? SizedBox(
                                        width: 120,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.file(
                                              cubit.pickedImage!,
                                            )))
                                    : Icon(
                                        Icons.image,
                                        color: AppColors.primary,
                                        size: 40,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 5,
                                          offset: Offset.fromDirection(5))
                                    ]),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month,
                                        color: AppColors.primary, size: 30),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                        "${now.year.toString()}-${now.month.toString()}-${now.day}"),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 40,
                            ),
                            DefaultElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (cubit.allAccountsName != null) {
                                      int index = cubit.allAccountsName!
                                          .indexWhere((element) =>
                                              element == allAccounts.text);
                                      String select1 =
                                          cubit.allAccounts![index]['id'];
                                      String? select2;
                                      if (cubit.allAccounts![index]['allsub'] !=
                                          null) {
                                        int index2 = cubit.allAccountsSub!
                                            .indexWhere((element) =>
                                                element == allSub.text);
                                        select2 = cubit.allAccounts![index]
                                            ['allsub'][index2]['id'];
                                      }
                                      int index3 = cubit.invoice!.indexWhere(
                                          (element) =>
                                              element == dropType.text);
                                      String select3 = cubit.invoiceEn![index3];

                                      cubit.addInvoice(
                                          paymentType: select3,
                                          select1: select1,
                                          select2: select2 ?? "null",
                                          amount: price.text,
                                          description: description.text,
                                          type: widget.type[0],
                                          id: widget.id,
                                          startSay:
                                              "${now.year.toString()}-${now.month > 9 ? now.month : "0${now.month}"}-${now.day > 9 ? now.day : "0${now.day}"}");
                                    } else {
                                      int index3 = cubit.invoice!.indexWhere(
                                          (element) =>
                                              element == dropType.text);
                                      String select3 = cubit.invoiceEn![index3];
                                      cubit.addInvoice(
                                          paymentType: select3,
                                          select1: "null",
                                          select2: "null",
                                          amount: price.text,
                                          description: description.text,
                                          type: widget.type[0],
                                          id: widget.id,
                                          startSay:
                                              "${now.year.toString()}-${now.month > 9 ? now.month : "0${now.month}"}-${now.day > 9 ? now.day : "0${now.day}"}");
                                    }
                                  }
                                },
                                child: state is AddNewInvoiceLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'اضافة',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ))
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget itemWidget(
      {required String ar, required String en, required int index}) {
    return InkWell(
      onTap: () {
        selectedType = index;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: selectedType == index ? true : false,
                activeColor: AppColors.primary,
                onChanged: (onChanged) {}),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ar),
                Text(en),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
