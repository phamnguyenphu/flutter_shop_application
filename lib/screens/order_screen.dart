import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/order.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../widgets/order_item_widget.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchOrder();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'My Order',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: "Ordered"),
                Tab(text: "Packed"),
                Tab(text: "In Transit"),
                Tab(text: "Delivered"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Center(child: Text("Ordered")),
              ),
              Container(
                child: Center(child: Text("Packed")),
              ),
              Container(
                child: Center(child: Text("In Transit")),
              ),
              Container(
                child: Center(child: Text("Delivered")),
              ),
            ],
          )
          // _isLoading
          //     ? Center(
          //         child: CircularProgressIndicator(color: Colors.black,),
          //       )
          //     : ListView.builder(
          //         itemBuilder: (ctx, index) => OrderItemWidget(
          //           orderItem: orderData.orders[index],
          //           indexOrder: index,
          //         ),
          //         itemCount: orderData.orders.length,
          //       ),
          ),
    );
  }
}
