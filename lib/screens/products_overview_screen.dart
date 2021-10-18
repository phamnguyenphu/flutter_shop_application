import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/products.dart';
import 'package:flutter_shop_application/screens/cart_screen.dart';
import 'package:flutter_shop_application/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import 'dart:math';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;
  bool _isDrawerOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().catchError((onError){
        print(onError);
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(_isDrawerOpen ? 0.9 : 1.00)
        ..rotateZ(_isDrawerOpen ? pi / 12 : 0),
      duration: Duration(milliseconds: 500),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.menu),
            onTap: () {
              setState(() {
                if (_isDrawerOpen) {
                  setState(() {
                    xOffset = 0;
                    yOffset = 0;
                    _isDrawerOpen = false;
                  });
                } else {
                  setState(() {
                    xOffset = size.width - 150;
                    yOffset = size.height / 5;
                    _isDrawerOpen = true;
                  });
                }
              });
            },
          ),
          title: Text(
            'My Shop',
            style: Theme.of(context).textTheme.title,
          ),
          actions: [
            _showFavoritesOnly
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _showFavoritesOnly = false;
                      });
                    },
                    icon: Icon(Icons.favorite))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _showFavoritesOnly = true;
                      });
                    },
                    icon: Icon(Icons.list_alt)),
            Consumer<Cart>(
              builder: (_, value, ch) => Badge(
                child: ch!,
                value: value.cartItemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(),
                child: ProductsGrid(
                  showFavs: _showFavoritesOnly,
                ),
              ),
      ),
    );
  }
}
