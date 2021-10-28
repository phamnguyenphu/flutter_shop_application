import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:flutter_shop_application/screens/cart_screen.dart';
import 'package:flutter_shop_application/screens/drawer_screen.dart';
import 'package:flutter_shop_application/screens/edit_product_screen.dart';
import 'package:flutter_shop_application/screens/order_screen.dart';
import 'package:flutter_shop_application/screens/payment_screen.dart';
import 'package:flutter_shop_application/screens/products_overview_screen.dart';
import 'package:flutter_shop_application/screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/order.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

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
        child: Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              canvasColor: Colors.white,
              primarySwatch: Colors.orange,
              // ignore: deprecated_member_use
              accentColor: Colors.orange,
              fontFamily: 'Lato',
              textTheme: TextTheme(
                  subtitle1: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                  bodyText1: TextStyle(
                      fontSize: 13.sp,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold),
                  bodyText2: TextStyle(
                      color: Colors.red,
                      fontSize: 13.sp,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold),
                  subtitle2: TextStyle(
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                  headline4: TextStyle(
                    fontSize: 20.sp,
                    letterSpacing: 0.5,
                  ),
                  headline3: TextStyle(
                    fontSize: 15,
                  )),
              appBarTheme: AppBarTheme(
                color: Colors.white,
                elevation: 0.0,
                centerTitle: true,
              ),
            ),
            home:
                // AuthenScreen(),
                Scaffold(
              body: Stack(
                children: [
                  DrawerScreen(),
                  ProductsOverviewScreen(),
                ],
              ),
            ),
            routes: {
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              PaymentScreen.routeName: (ctx) => PaymentScreen(),
            },
          );
        }));
  }
}
