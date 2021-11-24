import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:flutter_shop_application/screens/auth_screen.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              offset: const Offset(4, 4),
              blurRadius: 6.0),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: GridTile(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black54,
              leading: Consumer<Product>(
                builder: (ctx, value, _) => IconButton(
                  // ignore: deprecated_member_use
                  color: Theme.of(context).accentColor,
                  icon: value.isFavorite == null
                      ? Icon(Icons.favorite_border, color: Colors.red)
                      : value.isFavorite
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    authData.email == 'guest@guest.com'
                        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                              'To perform the function please login! Click ->',
                              style: TextStyle(color: Colors.black),
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color.fromRGBO(252, 207, 218, 1),
                            action: SnackBarAction(
                              label: 'LOGIN',
                              onPressed: () {
                                Provider.of<Auth>(context, listen: false)
                                    .logOut();
                                Provider.of<User>(context, listen: false)
                                    .logout();
                              },
                            ),
                          ))
                        : value.toggleFavorite(
                            authData.token!, authData.userId!);
                  },
                ),
              ),
              trailing: IconButton(
                // ignore: deprecated_member_use
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title,
                      product.imageUrl);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'Added item to cart!',
                      style: TextStyle(color: Colors.black),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Color.fromRGBO(252, 207, 218, 1),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
