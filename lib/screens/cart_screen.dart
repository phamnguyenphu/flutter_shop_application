import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/order.dart';
import 'package:flutter_shop_application/widgets/cart_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: cart.items.isEmpty
                  ? Center(
                      child: const Text(
                        'No have any item!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, index) => CartItemWidget(
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
            Divider(),
            Expanded(
              flex: 1,
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: 20.0, left: 30, right: 30, top: 0),
                        width: double.infinity,
                        child: OrderButton(cart: cart),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: _isLoading
            ? SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
                height: 25,
              )
            : Text(
                'Order Now',
                style: TextStyle(fontSize: 20),
              ),
      ),
      color: Colors.black,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
