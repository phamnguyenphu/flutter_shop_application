import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_shop_application/providers/order_item.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  final int indexOrder;

  OrderItemWidget({required this.orderItem, required this.indexOrder});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.event_note,
                      color: Colors.white,
                    ),
                    radius: 35.0,
                    backgroundColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order # ${widget.indexOrder}'),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.orderItem.productsOrder.length > 1
                              ? '${widget.orderItem.productsOrder.length} items'
                              : '${widget.orderItem.productsOrder.length} item',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID Order',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(widget.orderItem.id.substring(14)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date Order',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(DateFormat.yMMMd().format(widget.orderItem.dateTime)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Product',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'More',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: _expanded
                      ? Icon(Icons.expand_less)
                      : Icon(
                          Icons.expand_more,
                        ),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
            if (_expanded)
              Container(
                height: 40.0 * widget.orderItem.productsOrder.length,
                child: ListView(
                  children: widget.orderItem.productsOrder
                      .map(
                        (e) => Container(
                          height: 30,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Text(
                                '\$${e.price}' + ' x ' + '${e.quantily}',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
