import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/core/widgets/default_form_field.dart';
import 'package:account_gold/layout/company/add_company_screen.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:account_gold/layout/invoice/invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyScreen extends StatefulWidget {
  final String url;
  final String id;
  final String? name;
  final String type;
  const CompanyScreen(
      {Key? key,
      required this.url,
      required this.id,
      this.name,
      required this.type})
      : super(key: key);

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  @override
  void initState() {
    super.initState();

    AppCubit.get(context).getCompanyData(url: widget.url, id: widget.id);
  }

  bool search = false;
  String? searchValue;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.name ?? "",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.primary,
            leading: search ? const SizedBox() : null,
            actions: [
              const SizedBox(
                width: 15,
              ),
              search && cubit.companyModel?.send != null
                  ? Expanded(
                      child: DefaultFormField(
                      onChanged: (String value) {
                        searchValue = value;
                        print(searchValue);
                        setState(() {});
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                        hintStyle:
                            TextStyle(color: AppColors.text, fontSize: 16),
                        labelText: 'بحث',
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                    ))
                  : const SizedBox(),
              IconButton(
                  onPressed: () {
                    search = !search;
                    setState(() {});
                  },
                  icon: Icon(
                    search ? Icons.clear : Icons.search,
                    size: 28,
                  )),
            ],
          ),
          floatingActionButton: cubit.companyModel?.buttonAdd != null &&
                  cubit.companyModel!.buttonAdd == "ok"
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCompanyScreen(
                          id: widget.id,
                          type: widget.type,
                        ),
                      ),
                    );
                  },
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : null,
          body: cubit.companyModel?.send != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.18,
                          child: ListView.separated(
                              itemBuilder: (context, index) => itemWidget(
                                    name: search
                                        ? cubit.companyModel!.all!
                                                .where((element) =>
                                                    element.name!.contains(
                                                        searchValue ?? ""))
                                                .toList()[index]
                                                .name ??
                                            ''
                                        : cubit.companyModel!.all![index].name!,
                                    balance: search
                                        ? cubit.companyModel!.all!
                                                .where((element) =>
                                                    element.name!.contains(
                                                        searchValue ?? ""))
                                                .toList()[index]
                                                .balance ??
                                            0.0
                                        : cubit
                                            .companyModel!.all![index].balance!,
                                    id: search
                                        ? cubit.companyModel!.all!
                                                .where((element) =>
                                                    element.name!.contains(
                                                        searchValue ?? ""))
                                                .toList()[index]
                                                .id ??
                                            ''
                                        : cubit.companyModel!.all![index].id!,
                                  ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 15,
                                  ),
                              itemCount: search
                                  ? cubit.companyModel!.all!
                                      .where((element) => element.name!
                                          .contains(searchValue ?? ""))
                                      .length
                                  : cubit.companyModel!.all!.length),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
        );
      },
    );
  }

  Widget itemWidget(
      {required String name,
      required String balance,
      required String id,
      String? type}) {
    return InkWell(
      onTap: () {
        AppCubit.get(context).invoiceModel?.balance = null;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InvoiceScreen(
                      id: id,
                      type: type,
                      name: name,
                    )));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 1.8,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset.fromDirection(5),
                        blurRadius: 5)
                  ]),
              padding: const EdgeInsets.all(15),
              child: Text(name)),
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
                color: double.parse(balance) > 0
                    ? AppColors.primary
                    : Colors.redAccent,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  balance,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "الرصيد",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
