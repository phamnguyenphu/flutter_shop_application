import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:flutter_shop_application/widgets/payment_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = "/payment";
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(thickness: 0.1.h, color: Colors.grey.shade200),
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.all(5.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: Colors.green),
                                SizedBox(width: 1.w),
                                Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text('Deliver address',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1),
                                      SizedBox(height: 0.5.h),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: 'Trần Thái Tuấn',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        TextSpan(
                                            text: ' | ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        TextSpan(
                                            text: '(+84) 338671454',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                      ])),
                                      Text('Ấp bình tả 2',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Text('Huyện Đức Hòa, Long An',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2)
                                    ])),
                              ],
                            ),
                            Spacer(),
                            Icon(Icons.keyboard_arrow_right_rounded)
                          ],
                        )),
                    onTap: () {},
                  ),
                  Divider(thickness: 0.5.h, color: Colors.grey.shade200),
                  Row(
                    children: [
                      Icon(Icons.list_alt, color: Colors.lightBlue),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'List Product',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.sp)),
                    height: 14.h * cart.items.length,
                    child: ListView.builder(
                      itemBuilder: (ctx, index) => PaymentWidget(
                        id: cart.items.values.toList()[index].id,
                        title: cart.items.values.toList()[index].title,
                        price: cart.items.values.toList()[index].price,
                        quanlity: cart.items.values.toList()[index].quantily,
                        imgUrl: cart.items.values.toList()[index].imgUrl,
                        productId: cart.items.keys.toList()[index],
                      ),
                      itemCount: cart.items.length,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                    child: Row(
                      children: [
                        Text('Total :',
                            style: Theme.of(context).textTheme.headline6),
                        Spacer(),
                        Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyText2)
                      ],
                    ),
                  ),
                  Divider(thickness: 0.5.h, color: Colors.grey.shade200),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(LineAwesomeIcons.alternate_ticket,
                              color: Colors.orangeAccent),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text('Voucher',
                              style: Theme.of(context).textTheme.bodyText1),
                          Spacer(),
                          Text('Choose voucher',
                              style: Theme.of(context).textTheme.subtitle2),
                          Icon(Icons.keyboard_arrow_right_rounded),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 0.5.h, color: Colors.grey.shade200),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(LineAwesomeIcons.comments_dollar,
                              color: Colors.purple),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text('Payment Options',
                              style: Theme.of(context).textTheme.bodyText1),
                          Spacer(),
                          Text('Cash',
                              style: Theme.of(context).textTheme.subtitle2),
                          Icon(Icons.keyboard_arrow_right_rounded),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 0.5.h, color: Colors.grey.shade200),
                  Container(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Total amount of goods',
                                  style: Theme.of(context).textTheme.subtitle2),
                              Spacer(),
                              Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.subtitle2)
                            ],
                          ),
                          SizedBox(height: 0.3.h),
                          Row(
                            children: [
                              Text('Total shipping fee',
                                  style: Theme.of(context).textTheme.subtitle2),
                              Spacer(),
                              Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.subtitle2)
                            ],
                          ),
                          SizedBox(height: 0.3.h),
                          Row(
                            children: [
                              Text('Total discount vouche',
                                  style: Theme.of(context).textTheme.subtitle2),
                              Spacer(),
                              Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.subtitle2)
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Text('Total payment',
                                  style: Theme.of(context).textTheme.headline6),
                              Spacer(),
                              Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyText2)
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Divider(thickness: 0.5.h, color: Colors.grey.shade200),
          Container(
            child: Row(
              children: [
                Spacer(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total payment',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.normal)),
                      SizedBox(height: 0.5.h),
                      Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13.sp,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                    width: 30.w,
                    decoration: BoxDecoration(color: Colors.red),
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Order Now',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )))
              ],
            ),
          )
        ],
      )),
    );
  }
}
