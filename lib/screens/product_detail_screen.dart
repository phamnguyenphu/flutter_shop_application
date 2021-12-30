import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:flutter_shop_application/providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int activeSize = 0;
  bool isTop = true;
  bool isBottom = false;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final value = loadedProduct.type == 'Kid' ? 13 : 12;
    final min = loadedProduct.type == 'Kid' ? 1 : 35;
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                )
              ], borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: Stack(
                children: <Widget>[
                  //image
                  FadeInDown(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: ClipRRect(
                        child: Image.network(
                          loadedProduct.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FadeInDown(
              delay: Duration(milliseconds: 350),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  loadedProduct.title,
                  style: TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w600, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FadeInDown(
              delay: Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  "\$ " + '${loadedProduct.price}',
                  style: TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w500, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FadeInDown(
                      delay: Duration(milliseconds: 450),
                      child: Text(
                        "Size",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    FadeInDown(
                      delay: Duration(milliseconds: 450),
                      child: Text(
                        "Type: ${loadedProduct.type}",
                        style: TextStyle(
                            fontSize: 15, color: Colors.black.withOpacity(0.7)),
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 25,
            ),
            FadeInDown(
                delay: Duration(milliseconds: 500),
                child: Stack(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 25),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollEnd) {
                            isBottom = false;
                            isTop = false;
                            final metrics = scrollEnd.metrics;
                            if (metrics.atEdge) {
                              isTop = metrics.pixels == 0;
                              isBottom = metrics.pixels ==
                                  scrollEnd.metrics.maxScrollExtent;
                              isTop = metrics.pixels ==
                                  scrollEnd.metrics.minScrollExtent;
                              if (isBottom) {
                                setState(() {
                                  isBottom = true;
                                });
                              } else if (isTop) {
                                setState(() {
                                  isTop = true;
                                });
                              } else {
                                setState(() {
                                  isBottom = false;
                                  isTop = false;
                                });
                              }
                            }
                            return true;
                          },
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(value, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      activeSize = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, bottom: 5, left: 5, top: 5),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: activeSize == index
                                              ? Colors.black
                                              : Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 0.5,
                                                blurRadius: 1,
                                                color: Colors.black
                                                    .withOpacity(0.1))
                                          ]),
                                      child: Center(
                                        child: Text(
                                          (min + index).toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: activeSize == index
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        )),
                    if (!isBottom)
                      Positioned(
                        child: Icon(Icons.arrow_right,
                            size: 35, color: Colors.grey),
                        right: 0,
                        top: 12,
                      ),
                    if (!isTop)
                      Positioned(
                        child: Icon(Icons.arrow_left,
                            size: 35, color: Colors.grey),
                        left: -5,
                        top: 12,
                      ),
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            FadeInDown(
              delay: Duration(milliseconds: 550),
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 0.5,
                                  blurRadius: 1,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            color: Colors.grey.shade100),
                        child: loadedProduct.isFavorite
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.grey,
                              )),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                        // ignore: deprecated_member_use
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Colors.black,
                            onPressed: () {
                              cart.addItem(
                                  loadedProduct.id,
                                  loadedProduct.price,
                                  loadedProduct.title,
                                  loadedProduct.imageUrl,
                                  activeSize);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                  'Added item to cart!',
                                  style: TextStyle(color: Colors.black),
                                ),
                                duration: Duration(seconds: 2),
                                backgroundColor:
                                    Color.fromRGBO(252, 207, 218, 1),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    cart.removeSingleItem(loadedProduct.id);
                                  },
                                ),
                              ));
                            },
                            child: Container(
                              height: 50,
                              child: Center(
                                child: Text(
                                  "ADD TO CART",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
