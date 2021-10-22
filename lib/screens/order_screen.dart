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
                Tab(
                    text: "Ordered",
                    icon: Icon(Icons.my_library_books_outlined,
                        color: Colors.amber)),
                Tab(
                    text: "Packed",
                    icon:
                        Icon(Icons.wallet_giftcard_sharp, color: Colors.blue)),
                Tab(
                    text: "In Transit",
                    icon: Icon(Icons.delivery_dining_sharp,
                        color: Colors.orange)),
                Tab(
                    text: "Delivered",
                    icon: Icon(
                      Icons.check_box,
                      color: Colors.green,
                    )),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : orderData.listOrdered.length == 0
                          ? Center(
                              child: Text('No order any in this status'),
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, index) => OrderItemWidget(
                                orderItem: orderData.listOrdered[index],
                                indexOrder: index,
                              ),
                              itemCount: orderData.listOrdered.length,
                            )),
              Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : orderData.listPacked.length == 0
                          ? Center(
                              child: Text('No order any in this status'),
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, index) => OrderItemWidget(
                                orderItem: orderData.listPacked[index],
                                indexOrder: index,
                              ),
                              itemCount: orderData.listPacked.length,
                            )),
              Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : orderData.listIntransit.length == 0
                          ? Center(
                              child: Text('No order any in this status'),
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, index) => OrderItemWidget(
                                orderItem: orderData.listIntransit[index],
                                indexOrder: index,
                              ),
                              itemCount: orderData.listIntransit.length,
                            )),
              Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : orderData.listDelivered.length == 0
                          ? Center(
                              child: Text('No order any in this status'),
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, index) => OrderItemWidget(
                                orderItem: orderData.listDelivered[index],
                                indexOrder: index,
                              ),
                              itemCount: orderData.listDelivered.length,
                            ))
            ],
          )),
    );
  }
}
