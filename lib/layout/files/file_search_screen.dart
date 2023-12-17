import 'dart:io';

import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/core/widgets/default_elevated_button.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/data/files_model.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileSearchScreen extends StatelessWidget {
  final String page;
   FileSearchScreen({Key? key, required this.page}) : super(key: key);

  var search = TextEditingController();



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
                    cubit.listFilesModel.clear();
                    cubit.filesModel = null;
                    cubit.fIndex = 1;
                    cubit.getFilesData(page: page, url: "", id: "", number: 0, subId: "");

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear))
            ],
            title: DefaultFormField(
              onChanged: (String value){
                if(value.length > 2){
                  cubit.getSearchFilesData(page: page, value: value,);
                }else{
                  cubit.listFilesModel.clear();
                  cubit.emitNewState();
                }
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
          body: cubit.listFilesModel.isNotEmpty ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index)=> fileWidget(model: cubit.listFilesModel[index], context: context),
                      separatorBuilder: (context, index)=> const SizedBox(height: 15,),
                      itemCount: cubit.listFilesModel.length),
                )
              ],
            ),
          ) : search.text.isEmpty ? const Center(child: Text("ابحث في الملفات..."),) : const Center(child: Text("لا يوجد نتائج مطابقة"),)
          ,
        );
      },
    );
  }

  Widget fileWidget({required AllFiles model, required BuildContext context}){
    return InkWell(
      onTap: (){
        if(model.file1 != null && model.file2 != null){
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,

                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.download_for_offline, color: AppColors.primary, size: 34,),
                            const SizedBox(width: 10,),
                            TextButton(
                                onPressed: () async{
                                  getExternalStorageDirectory().then((value) {
                                    var name = model.file1!.split('/').last;
                                    String? fileName = "${value!.path}/$name";
                                    final downloader= MediaDownload();
                                    Navigator.pop(context);
                                    Constants.showToast(msg: "جاري التحميل");
                                    downloader.downloadMedia(context, model.file1!, ).then((value) async{
                                      if(await File(fileName).exists()){
                                        await Share.shareXFiles([XFile(fileName)]);

                                      }
                                    });
                                  });

                                },
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary.withOpacity(0.1))),
                                child: Text("تحميل الملف الاول", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),)),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          children: [
                            Icon(Icons.download_for_offline, color: AppColors.primary, size: 34,),
                            const SizedBox(width: 10,),
                            TextButton(
                                onPressed: () async{
                                  getExternalStorageDirectory().then((value) {
                                    var name = model.file2!.split('/').last;
                                    String? fileName = "${value!.path}/$name";
                                    final downloader= MediaDownload();
                                    Navigator.pop(context);
                                    Constants.showToast(msg: "جاري التحميل");
                                    downloader.downloadMedia(context, model.file2!, ).then((value) async{
                                      if(await File(fileName).exists()){
                                        await Share.shareXFiles([XFile(fileName)]);

                                      }
                                    });
                                  });
                                },
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary.withOpacity(0.1))),
                                child: Text("تحميل الملف الثاني", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),)),
                          ],
                        ),],
                    ),
                  ),
                );
              });
        }else if (model.file1 != null){
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
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'هل تريد تحمبل الـملف ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                    AppColors.primary,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Center(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DefaultElevatedButton(
                                          onPressed: () async{
                                            getExternalStorageDirectory().then((value) {
                                              var name = model.file1!.split('/').last;
                                              String? fileName = "${value!.path}/$name";
                                              final downloader= MediaDownload();
                                              Navigator.pop(context);
                                              Constants.showToast(msg: "جاري التحميل");
                                              downloader.downloadMedia(context, model.file1!, ).then((value) async{
                                                if(await File(fileName).exists()){
                                                  await Share.shareXFiles([XFile(fileName)]);

                                                }
                                              });
                                            });              // FlutterDownloader.enqueue(

                                          },
                                          child: const Text(
                                            'نعم',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    const SizedBox(width: 15,),
                                    Expanded(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'لا',
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

        }else{
          Constants.showToast(msg: "لا يوجد رابط مرفق لتحميلة");
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width/2, child: Text(model.name!)),
                const Spacer(),
                IconButton(onPressed: (){
                  if(model.file1 != null && model.file2 != null){
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 150,
                            width: MediaQuery.of(context).size.width,

                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.download_for_offline, color: AppColors.primary, size: 34,),
                                      const SizedBox(width: 10,),
                                      TextButton(
                                          onPressed: () async{
                                            getExternalStorageDirectory().then((value) {
                                              var name = model.file1!.split('/').last;
                                              String? fileName = "${value!.path}/$name";
                                              final downloader= MediaDownload();
                                              Navigator.pop(context);
                                              Constants.showToast(msg: "جاري التحميل");
                                              downloader.downloadMedia(context, model.file1!, ).then((value) async{
                                                if(await File(fileName).exists()){
                                                  await Share.shareXFiles([XFile(fileName)]);

                                                }
                                              });
                                            });

                                          },
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary.withOpacity(0.1))),
                                          child: Text("تحميل الملف الاول", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),)),
                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    children: [
                                      Icon(Icons.download_for_offline, color: AppColors.primary, size: 34,),
                                      const SizedBox(width: 10,),
                                      TextButton(
                                          onPressed: () async{
                                            getExternalStorageDirectory().then((value) {
                                              var name = model.file2!.split('/').last;
                                              String? fileName = "${value!.path}/$name";
                                              final downloader= MediaDownload();
                                              Navigator.pop(context);
                                              Constants.showToast(msg: "جاري التحميل");
                                              downloader.downloadMedia(context, model.file2!, ).then((value) async{
                                                if(await File(fileName).exists()){
                                                  await Share.shareXFiles([XFile(fileName)]);

                                                }
                                              });
                                            });
                                          },
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary.withOpacity(0.1))),
                                          child: Text("تحميل الملف الثاني", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),)),
                                    ],
                                  ),],
                              ),
                            ),
                          );
                        });
                  }else if (model.file1 != null){
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
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'هل تريد تحمبل الـملف',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color:
                                              AppColors.primary,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Center(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: DefaultElevatedButton(
                                                    onPressed: () async{
                                                      getExternalStorageDirectory().then((value) {
                                                        var name = model.file1!.split('/').last;
                                                        String? fileName = "${value!.path}/$name";
                                                        final downloader= MediaDownload();
                                                        Navigator.pop(context);
                                                        Constants.showToast(msg: "جاري التحميل");
                                                        downloader.downloadMedia(context, model.file1!, ).then((value) async{
                                                          if(await File(fileName).exists()){
                                                            await Share.shareXFiles([XFile(fileName)]);

                                                          }
                                                        });
                                                      });
                                                    },
                                                    child: const Text(
                                                      'نعم',
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                    )),
                                              ),
                                              const SizedBox(width: 15,),
                                              Expanded(
                                                child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'لا',
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

                  }else{
                    Constants.showToast(msg: "لا يوجد رابط مرفق لتحميلة");
                  }
                }, icon: Icon(Icons.download_for_offline, color: AppColors.primary,))
              ],
            ),
            const SizedBox(height: 20),
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
                        "تاريخ الانتهاء",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        model.date!,
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
                        "الحالة",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        model.type == 1 ? "منتهي" : "غير منتهي",
                        style: TextStyle(fontWeight: FontWeight.bold, color: model.type == 1 ? Colors.red : Colors.green),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            const SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child:   Text(
                model.daterest!,
                style: const TextStyle(fontSize: 16),
              ),
            ),

          ],
        ),
      ),
    );

  }

}
