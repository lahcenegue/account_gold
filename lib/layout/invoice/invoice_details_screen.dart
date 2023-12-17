import 'package:account_gold/core/widgets/text_widget.dart';
import 'package:account_gold/layout/invoice/image_details.dart';
import 'package:flutter/material.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final String balance;
  final String amount;
  final String payBy;
  final String type;
  final String user;
  final String payType;
  final String date;
  final String desc;
  final String img;
  const InvoiceDetailsScreen({Key? key, required this.balance, required this.amount, required this.desc, required this.img, required this.date, required this.payBy, required this.payType, required this.user, required this.type}) : super(key: key);

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الفاتورة"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("الرصيد", style: TextStyle(fontSize: 16),),
                        Text(widget.balance, style: const TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const Spacer(),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("المبلغ", style: TextStyle(fontSize: 16),),
                        Text(widget.amount, style: TextStyle(color: widget.type == "2"? Colors.green : Colors.red, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     const Text("التاريخ", style: TextStyle(fontSize: 16),),
                     Text(widget.date,style: const TextStyle(fontWeight: FontWeight.bold),),
                   ],),
                 ),
                  const SizedBox(width: 10,),

                  const Spacer(),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("اليوزر", style: TextStyle(fontSize: 16),),
                        Text(widget.user, style: const TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15,),

              Row(
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("النوع", style: TextStyle(fontSize: 16),),
                        Text(widget.payType, style: const TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),

                  const Spacer(),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("بواسطة", style: TextStyle(fontSize: 16),),
                        Text(widget.payBy, style: const TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),


              const SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                  padding: const EdgeInsets.all(10),
                  child: TextWidget(value: widget.desc)),
              const SizedBox(height: 20,),

              widget.img.isEmpty ? const Center(child:  Text("لا يوجد صورة")) : InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ImageDetails(img: widget.img,)));
                  },
                  child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network(widget.img)))
            ],

          ),
        ),
      ),
    );
  }
}
