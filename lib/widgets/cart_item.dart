import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String title;

  final String imgUrl;
  final double price;
  final int quanlity;
  final String id;
  final String productId;

  CartItemWidget({
    required this.title,
    required this.imgUrl,
    required this.price,
    required this.quanlity,
    required this.id,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              elevation: 5.0,

              backgroundColor: Color.fromRGBO(252, 207, 218, 1),
                  title: Row(
                    children: [
                      Icon(Icons.warning_rounded, size: 20.0, color: Theme.of(context).errorColor,),
                      SizedBox(width: 15.0,),
                      Text('Are you sure?')
                    ],
                  ),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No')),
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes')),
                  ],
                ));
      },
      background: Row(
        children: [
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Theme.of(context).errorColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              alignment: Alignment.center,
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      direction: DismissDirection.endToStart,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 6.0),
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        '\$$price',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
                Text(
                  'x $quanlity',
                  style: Theme.of(context).textTheme.subtitle2,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
