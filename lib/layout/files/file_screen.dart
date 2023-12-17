import 'dart:io';
import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/utils/constant.dart';
import 'package:account_gold/core/widgets/default_elevated_button.dart';
import 'package:account_gold/data/files_model.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:account_gold/layout/files/file_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileScreen extends StatefulWidget {
  final String page;
  final String? id;
  final String? subId;
  final String? url;
  final int number;
  final int selectedCat;
  final String title;
  const FileScreen({Key? key, required this.page, this.id, this.url, required this.number, this.subId, required this.selectedCat, required this.title}) : super(key: key);

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  ScrollController scrollController = ScrollController();
  scrollListener() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      AppCubit.get(context).getFilesData(page: widget.page, url: widget.url??"", id: widget.id??"", subId: widget.subId??"", number: widget.number);
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    AppCubit.get(context).getFilesData(page: widget.page, url: widget.url??"", id: widget.id??"", subId: widget.subId??"", number: widget.number);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){

        var cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: ()async{
            if(widget.number == 1){
              AppCubit.get(context).fIndex = 1;
              AppCubit.get(context).filesModel = null;
              AppCubit.get(context).listFilesModel.clear();
              AppCubit.get(context).thereIsNoFiles = false;
              Navigator.pop(context);
              AppCubit.get(context).getFilesData(
                  page: widget.page, url: "", id: "", subId: "", number: 0);
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(onPressed: (){
                  cubit.listFilesModel.clear();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> FileSearchScreen(page: widget.page)));

                }, icon: const Icon(Icons.search))
              ],
            ),
            backgroundColor: Colors.grey.shade100,
            body: cubit.filesModel?.all != null?  Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [

                  cubit.allcat.isNotEmpty && widget.number <2? SizedBox(
                   width: MediaQuery.of(context).size.width,
                   height: 50,
                   child: ListView.separated(
                       scrollDirection: Axis.horizontal,
                       itemBuilder: (context, index)=> catItems(cubit.allcat[index].name!, index, widget.page, cubit),
                       separatorBuilder: (context, index)=> const SizedBox(width: 10,),
                       itemCount: cubit.allcat.length),
                 ) : const SizedBox(),
                  const SizedBox(height: 30,),
                  cubit.filesModel?.all != null && cubit.filesModel!.all!.isNotEmpty ? Expanded(
                    child: ListView.separated(
                        controller: scrollController,
                        itemBuilder: (context, index)=> fileWidget(model: cubit.listFilesModel[index]),
                        separatorBuilder: (context, index)=> const SizedBox(height: 15,),
                        itemCount: cubit.listFilesModel.length),
                  ) : cubit.filesModel?.all != null && cubit.filesModel!.all!.isEmpty ? const Center(child: Text("لا يوجد بيانات")): const SizedBox()
                ],
              ),
            )  : Center(child: CircularProgressIndicator(color: AppColors.primary,),),
          ),
        );
      },
    );
  }

  Widget catItems(String name, int index, String page, AppCubit cubit){
    return InkWell(
      onTap: (){
        cubit.filesModel?.all = null;
        cubit.listFilesModel.clear();
        cubit.fIndex = 1;
        widget.number == 0 ? Navigator.push(context, MaterialPageRoute(builder: (context)=> FileScreen(title: name, page: page, id: cubit.allcat[index].id!.toString(), url: cubit.allcat[index].page!, number: widget.number+1, selectedCat: -1,)))
        : Navigator.push(context, MaterialPageRoute(builder: (context)=> FileScreen(title: name, page: page, id: widget.id, subId: cubit.allcat[index].id!.toString(), url: cubit.allcat[index].page!, number: widget.number+1, selectedCat: index,)));
        },
      child: Container(
        decoration: BoxDecoration(
            color:  widget.selectedCat == index ? AppColors.primary : null,
            border: widget.selectedCat == index ? null : Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(25)
        ),
        height: 50,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text(name, style: TextStyle(color:  widget.selectedCat == index ? Colors.white : AppColors.primary), textAlign: TextAlign.center,),
      ),
    );
  }

  Widget fileWidget({required AllFiles model}){
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
                                          onPressed: (){
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
                                          onPressed: () async{
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
                    width: 145,
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
                  const SizedBox(width: 10,),
                  const Spacer(),
                  Container(
                    width: 145,
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
                          model.type == 2 ? "منتهي" : "غير منتهي",
                          style: TextStyle(fontWeight: FontWeight.bold, color: model.type == 2 ? Colors.red : Colors.green),
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
