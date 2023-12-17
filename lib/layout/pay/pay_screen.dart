import 'package:account_gold/core/utils/app_colors.dart';
import 'package:account_gold/layout/cubit/cubit.dart';
import 'package:account_gold/layout/pay/add_new_pay_screen.dart';
import 'package:account_gold/layout/pay/history_layout.dart';
import 'package:account_gold/layout/pay/pay_search_screen.dart';
import 'package:account_gold/layout/pay/payment_layout.dart';
import 'package:flutter/material.dart';

class PayScreen extends StatefulWidget {
  final String url;
  final String page;
  const PayScreen({Key? key, required this.url, required this.page}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {

  var _kTabPages = <Widget>[];

  final _kTabs = <Tab>[
    const Tab(
      text: 'جميع العمليات',
    ),
    const Tab(
      text: 'سجل المدفوعات',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _kTabPages = <Widget>[
      PaymentLayout(page: widget.page, url: widget.url,),
      HistoryLayout(page: widget.page, url: widget.url,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("عمليات الدفع"),
          actions: [
            IconButton(
                onPressed: (){
                  AppCubit.get(context).listPaymentModel.clear();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PaySearchScreen(url: widget.url, page: widget.page,)));
                },
                icon: const Icon(Icons.search))
          ],
          bottom: TabBar(
            tabs: _kTabs,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey.shade300,
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewPayScreen()));
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white,),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: _kTabPages,

        )
      ),
    );
  }
}
