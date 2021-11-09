import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:flutter_shop_application/screens/auth_screen.dart';
import 'package:flutter_shop_application/screens/order_screen.dart';
import 'package:flutter_shop_application/screens/profile_screen.dart';
import 'package:flutter_shop_application/screens/user_product_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<User>(context, listen: false).getUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context).user;
    return isLoading
        ? Center(child: Lottie.asset('assets/images/loading_plane_paper.json'))
        : Container(
            padding: EdgeInsets.only(top: 50.0, left: 20.0),
            width: double.infinity,
            color: Color.fromRGBO(252, 207, 218, 0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            user.avatar == ''
                                ? 'https://firebasestorage.googleapis.com/v0/b/flutter-shop-d0a51.appspot.com/o/avatar.jpg?alt=media&token=cdb54cc3-6514-4e4f-b69b-8794450d2da3'
                                : user.avatar,
                            scale: 1.0),
                        radius: 50.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        user.fullName == '' ? 'User Name' : user.fullName,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(user.email == '' ? 'abc123@gmail.com' : user.email,
                          style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
                user.email == ''
                    ? Container(
                        margin: EdgeInsets.only(top: 40.0),
                        child: Column(children: [
                          ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AuthenScreen.routeName);
                            },
                            leading: Icon(Icons.lock),
                            title: Text('Login'),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AuthenScreen.routeName);
                            },
                            leading: Icon(Icons.info),
                            title: Text('About'),
                          ),
                        ]))
                    : Container(
                        margin: EdgeInsets.only(top: 40.0),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                          email: user.email,
                                          isSignUp: false,
                                        )));
                              },
                              leading: Icon(Icons.account_box),
                              title: Text('Profile'),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(OrderScreen.routeName);
                              },
                              leading: Icon(Icons.task),
                              title: Text('Order'),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(UserProductScreen.routeName);
                              },
                              leading: Icon(Icons.settings),
                              title: Text('Products'),
                            ),
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text('About'),
                            ),
                            ListTile(
                              leading: Icon(Icons.logout),
                              title: Text('Log out'),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          elevation: 5.0,
                                          backgroundColor: Colors.white,
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.warning_rounded,
                                                size: 20.0,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Text('Are you sure?')
                                            ],
                                          ),
                                          content: Text(
                                              'Do you want to sign out of the app?'),
                                          actions: [
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('No')),
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                                onPressed: () {
                                                  Provider.of<Auth>(context,
                                                          listen: false)
                                                      .logOut();
                                                  Provider.of<User>(context,
                                                          listen: false)
                                                      .logout();
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('Yes')),
                                          ],
                                        ));
                              },
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          );
  }
}
