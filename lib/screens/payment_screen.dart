import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/address.dart';
import 'package:flutter_shop_application/providers/addresses.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:flutter_shop_application/providers/order.dart';
import 'package:flutter_shop_application/providers/voucher.dart';
import 'package:flutter_shop_application/screens/address/address_screen.dart';
import 'package:flutter_shop_application/screens/order_screen.dart';
import 'package:flutter_shop_application/screens/payment_sheet_screen.dart';
import 'package:flutter_shop_application/screens/voucher_screen.dart';
import 'package:flutter_shop_application/widgets/address_item_widget.dart';
import 'package:flutter_shop_application/widgets/payment_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = "/payment";
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isLoading = false;
  bool _isWait = false;
  Address? defaultAddress;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Voucher>(context, listen: false).fetchVouchers();
      Provider.of<Voucher>(context, listen: false).removeDefault();
    });
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    defaultAddress = Provider.of<Addresses>(context).findDefaultAddress();
    final defaultVoucher = Provider.of<Voucher>(context).voucherDefaulst;
    final discountVoucher = cart.totalAmount * defaultVoucher.percent / 100;
    final totalShipping =
        defaultAddress!.address.contains('Thành phố Thủ Đức') ? 0 : 1;
    final totalDiscount = discountVoucher > defaultVoucher.maxDiscount
        ? defaultVoucher.maxDiscount
        : cart.totalAmount * defaultVoucher.percent / 100;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: _isWait
          ? Center(
              child: Lottie.asset('assets/images/loading_plane_paper.json'))
          : _isLoading
              ? Center(
                  child: Lottie.asset(
                  'assets/images/loading_shop.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ))
              : Container(
                  child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Divider(
                                thickness: 0.1.h, color: Colors.grey.shade200),
                            // ignore: unnecessary_null_comparison
                            defaultAddress != null
                                ? AddressItemWidget(
                                    name: defaultAddress!.fullName,
                                    phoneNumber: defaultAddress!.phoneNumber,
                                    // ignore: unnecessary_null_comparison
                                    address: defaultAddress!.address == null
                                        ? ''
                                        : defaultAddress!.address,
                                    handle: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) =>
                                                  AddressScreen()))
                                          .then((value) => {setState(() {})});
                                    })
                                : Container(
                                    child:
                                        Center(child: Text('No Address Now!')),
                                  ),
                            Divider(
                                thickness: 0.5.h, color: Colors.grey.shade200),
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
                                  title:
                                      cart.items.values.toList()[index].title,
                                  price:
                                      cart.items.values.toList()[index].price,
                                  quanlity: cart.items.values
                                      .toList()[index]
                                      .quantily,
                                  imgUrl:
                                      cart.items.values.toList()[index].imgUrl,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Spacer(),
                                  Text('${cart.totalAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 11.sp,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                            Divider(
                                thickness: 0.5.h, color: Colors.grey.shade200),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => VoucherScreen()));
                              },
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    Spacer(),
                                    Text(
                                        defaultVoucher.title == null
                                            ? 'Choose Voucher'
                                            : defaultVoucher.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Icon(Icons.keyboard_arrow_right_rounded),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                                thickness: 0.5.h, color: Colors.grey.shade200),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    Spacer(),
                                    Text('Cash',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Icon(Icons.keyboard_arrow_right_rounded),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                                thickness: 0.5.h, color: Colors.grey.shade200),
                            Container(
                                padding: EdgeInsets.all(8.0.sp),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Total amount of goods',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        Spacer(),
                                        Text(
                                            '${cart.totalAmount.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2)
                                      ],
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Row(
                                      children: [
                                        Text('Total shipping fee',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        Spacer(),
                                        Text(
                                            '- ${totalShipping.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2)
                                      ],
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Row(
                                      children: [
                                        Text('Total discount voucher',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        Spacer(),
                                        Text(
                                            '- ${totalDiscount.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2)
                                      ],
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        Text('Total payment',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                        Spacer(),
                                        Text(
                                            '${(cart.totalAmount - totalDiscount - totalShipping).toStringAsFixed(2)}',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13.sp,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.bold))
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
                                Text(
                                    '\$ ${(cart.totalAmount - totalDiscount- totalShipping).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15.sp,
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
                                  onPressed: defaultAddress == null
                                      ? () {}
                                      : () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          await Provider.of<Order>(context,
                                                  listen: false)
                                              .addOrder(
                                                  cart.items.values.toList(),
                                                  cart.totalAmount -
                                                      totalDiscount - totalShipping,
                                                  defaultAddress!.fullName,
                                                  defaultAddress!.phoneNumber,
                                                  defaultAddress!.address)
                                              .then((value) => {
                                                    Provider.of<Voucher>(
                                                            context,
                                                            listen: false)
                                                        .deleteVoucher(
                                                            defaultVoucher.id),
                                                  });
                                          Provider.of<Voucher>(context,
                                                  listen: false)
                                              .removeDefault();
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          // Navigator.of(context)
                                          //     .pushReplacementNamed(
                                          //         OrderScreen.routeName);
                                          // cart.clearCart();
                                    Navigator.of(context).pushNamed(PaymentSheetScreen.routeName);
                                        },
                                  child: Text(
                                    'Order Now',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )))
                        ],
                      ),
                    )
                  ],
                )),
    );
  }
}
