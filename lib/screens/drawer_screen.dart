import 'package:flutter/material.dart';
import 'package:flutter_shop_application/screens/order_screen.dart';
import 'package:flutter_shop_application/screens/user_product_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: Icon(Icons.person),
                  radius: 50.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Pham Nguyen Phu',
                  style: Theme.of(context).textTheme.body1,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'phamnguyenphucp9@gmail.com',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.account_box),
                  title: Text('Profile'),
                ),
                ListTile(
                  onTap: (){
                    Navigator.of(context).pushNamed(OrderScreen.routeName);
                  },
                  leading: Icon(Icons.task),
                  title: Text('Order'),
                ),
                ListTile(
                  onTap: (){
                    Navigator.of(context).pushNamed(UserProductScreen.routeName);
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
