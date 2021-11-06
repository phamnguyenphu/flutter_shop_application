import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/cart.dart';
import 'package:flutter_shop_application/providers/product.dart';
import 'package:flutter_shop_application/screens/auth_screen.dart';
import 'package:flutter_shop_application/screens/cart_screen.dart';
import 'package:flutter_shop_application/screens/drawer_screen.dart';
import 'package:flutter_shop_application/screens/edit_product_screen.dart';
import 'package:flutter_shop_application/screens/order_screen.dart';
import 'package:flutter_shop_application/screens/products_overview_screen.dart';
import 'package:flutter_shop_application/screens/splash/splash_screen.dart';
import 'package:flutter_shop_application/screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/order.dart';
import 'package:flutter/services.dart';

int? initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);

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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (_, auth, previousProducts) =>
                previousProducts!..update(auth.token, auth.userId)),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
            create: (_) => Order(),
            update: (_, auth, previousOrder) =>
                previousOrder!..update(auth.token, auth.userId)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => Sizer(
          builder: (context, orientation, deviceType) {
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
                        fontSize: 16,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold),
                    subtitle2: TextStyle(
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                    headline4: TextStyle(
                      fontSize: 28,
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
              home: auth.isSplash
                  ? (initScreen == 0 || initScreen == null)
                      ? SplashScreen()
                      : auth.isAuth
                          ? Scaffold(
                              body: Stack(
                                children: [
                                  DrawerScreen(),
                                  ProductsOverviewScreen(),
                                ],
                              ),
                            )
                          : AuthenScreen()
                  : auth.isAuth
                      ? Scaffold(
                          body: Stack(
                            children: [
                              DrawerScreen(),
                              ProductsOverviewScreen(),
                            ],
                          ),
                        )
                      : AuthenScreen(),
              routes: {
                ProductsOverviewScreen.routeName: (ctx) =>
                    ProductsOverviewScreen(),
                AuthenScreen.routeName: (ctx) => AuthenScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
                SplashScreen.routeName: (ctx) => SplashScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
