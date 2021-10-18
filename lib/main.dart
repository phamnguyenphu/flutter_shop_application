import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:flutter_shop_application/screens/auth_screen.dart';
import 'package:flutter_shop_application/screens/cart_screen.dart';
import 'package:flutter_shop_application/screens/drawer_screen.dart';
import 'package:flutter_shop_application/screens/edit_product_screen.dart';
import 'package:flutter_shop_application/screens/order_screen.dart';
import 'package:flutter_shop_application/screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop_application/screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/order.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          canvasColor: Colors.white,
          primarySwatch: Colors.orange,
          accentColor: Colors.orange,
          fontFamily: 'Lato',
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
            body1: TextStyle(
                fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.bold),
            subtitle: TextStyle(
              fontSize: 13,
              letterSpacing: 0.5,
            ),
            display1: TextStyle(
              fontSize: 28,
              letterSpacing: 0.5,
            ),
            display2: TextStyle(
              fontSize: 15,
            )
          ),
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0.0,
            centerTitle: true,
          ),
        ),
        home: AuthenScreen(),
        // Scaffold(
        //   body: Stack(
        //     children: [
        //       DrawerScreen(),
        //       ProductsOverviewScreen(),
        //     ],
        //   ),
        // ),
        routes: {

          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
