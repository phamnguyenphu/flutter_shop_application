import 'package:flutter/material.dart';
import 'package:flutter_shop_application/screens/address/create_address.dart';
import 'package:flutter_shop_application/widgets/address_item_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import 'address/edit_address.dart';

class AddressScreen extends StatelessWidget {
  static const routeName = "/address-screen";
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool status = true;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => CreateAddress()));
              },
            ),
          ],
          title: Text(
            'Address List',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, index) => Slidable(
              actionExtentRatio: 0.2,
              actionPane: SlidableStrechActionPane(),
              child: Card(
                child: Stack(
                  children: [
                    AddressItemWidget(
                      name: 'Trần Thái Tuấn',
                      phoneNumber: '(+84) 338671454',
                      street: 'số nhà 206',
                      wards: 'xã Đức Hòa Hạ',
                      district: 'huyện Đức Hòa',
                      city: 'Long An',
                      handle: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => EditAddress(
                                  name: 'Chopper',
                                  phoneNumber: '0338671454',
                                  address: 'xã Đức Hòa Hạ',
                                  defaultStatus: true,
                                )));
                      },
                    ),
                    status == false
                        ? Container()
                        : Positioned(
                            child: Text('Default',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10.sp,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.normal)),
                            top: 1.5.h,
                            right: 8.w),
                  ],
                ),
              ),
              secondaryActions: [
                IconSlideAction(
                    caption: "Edit",
                    color: Colors.yellow,
                    icon: Icons.edit,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => EditAddress(
                                name: 'Chopper',
                                phoneNumber: '0338671454',
                                address: 'xã Đức Hòa Hạ',
                                defaultStatus: true,
                              )));
                    }),
                IconSlideAction(
                    caption: "Delete",
                    color: Colors.red,
                    icon: Icons.delete,
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
                                      color: Theme.of(context).errorColor,
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Text('Are you sure?')
                                  ],
                                ),
                                content: Text(
                                    'Do you want to remove the item from the cart?'),
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
                                        // cart.removeItem(cart.items.keys
                                        //     .toList()[index]);
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('Yes')),
                                ],
                              ));
                    }),
              ]),
          itemCount: 10,
        ));
  }
}
