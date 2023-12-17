import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/data/payment_model.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentLayout extends StatefulWidget {
  final String page;
  final String url;
  const PaymentLayout({Key? key, required this.page, required this.url})
      : super(key: key);

  @override
  State<PaymentLayout> createState() => _PaymentLayoutState();
}

class _PaymentLayoutState extends State<PaymentLayout> {

  ScrollController scrollController = ScrollController();
  scrollListener() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
        AppCubit.get(context).getPaymentData(page: widget.page, url: widget.url);
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    AppCubit.get(context).getPaymentData(page: widget.page, url: widget.url);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {

          var cubit = AppCubit.get(context);

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: state is !PaymentDataLoading && cubit.listPaymentModel.isNotEmpty ? SizedBox(
              height: MediaQuery.of(context).size.height/1.2,
              child: ListView.separated(
                controller: scrollController,
                  itemBuilder: (context, index)=> itemWidget(cubit.listPaymentModel[index]),
                  separatorBuilder: (context, index)=> const SizedBox(height: 15  ,),
                  itemCount: cubit.listPaymentModel.length),
            ) : Center(child: CircularProgressIndicator(color: AppColors.primary,),)
          );
        });
  }
  
  Widget itemWidget(AllPayment model){
    return Container(
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
              Text(model.name!),
              const Spacer(),
              Text(model.amount!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
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
                      "الهاتف",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      model.mobile!,
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
                      "التاريخ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      model.date1!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
              model.comment!,
              style: const TextStyle(fontSize: 16),
            ),
          ),

        ],
      ),
    );
  }
  
}
