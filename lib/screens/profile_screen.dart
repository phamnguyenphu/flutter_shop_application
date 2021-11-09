import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/address.dart';
import 'package:flutter_shop_application/providers/addresses.dart';
import 'package:flutter_shop_application/widgets/sheet_address.dart';
import 'package:flutter_shop_application/widgets/widget.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_shop_application/providers/user.dart';

import 'drawer_screen.dart';
import 'products_overview_screen.dart';

enum listChoose { ChangePassword }

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  final String email;
  final bool isSignUp;
  const ProfileScreen({
    Key? key,
    required this.email,
    required this.isSignUp,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = new GlobalKey<FormState>();
  bool gender = true;
  String image =
      'https://firebasestorage.googleapis.com/v0/b/flutter-shop-d0a51.appspot.com/o/avatar.jpg?alt=media&token=cdb54cc3-6514-4e4f-b69b-8794450d2da3';
  String dropdownValue = 'Male';
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  bool init = true;
  bool isLoading = false;
  bool? shouldPop;
  DateTime selectedDate = DateTime.now();
  DateFormat formatDate = DateFormat('dd/MM/yyyy');

  Future<DateTime?> _selectDateTime(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now());
  @override
  void initState() {
    setState(() {
      shouldPop = widget.isSignUp ? false : true;
    });
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
      });
      Provider.of<AddressItems>(context, listen: false).deleteItem();
      await Provider.of<AddressItems>(context, listen: false).getDistrict();
      final user = Provider.of<User>(context, listen: false).user;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        _nameController.text = user.fullName;
        _birthdayController.text = user.birthday;
        _phoneNumberController.text = user.phoneNumber;
        _addressController.text = user.address;
        if (user.avatar != '') {
          image = user.avatar;
        }
        dropdownValue = user.gender ? 'Male' : 'Female';
      }
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<User>(context).userId;
    final address = Provider.of<AddressItems>(context).item;
    if (address != null) {
      setState(() {
        _addressController.text = address.stress +
            ', ' +
            address.ward +
            ', ' +
            address.districts +
            ', thành phố Hồ Chí Minh';
      });
    }
    final user = Provider.of<User>(context, listen: false).user;
    return WillPopScope(
        onWillPop: () async {
          return shouldPop!;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'My Profile',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            actions: [
              PopupMenuButton(
                onSelected: (listChoose selected) {
                  if (selected == listChoose.ChangePassword) {}
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    height: 5.h,
                    child: Text('Change Password',
                        style: Theme.of(context).textTheme.bodyText2),
                    value: listChoose.ChangePassword,
                  ),
                ],
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          body: isLoading
              ? Center(
                  child: Lottie.asset('assets/images/loading_plane_paper.json'))
              : Form(
                  key: _formkey,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(image),
                                    radius: 50,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.email,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            title('Full name:'),
                            BuildTextField(
                                TextInputType.text,
                                false,
                                'Please enter your full name!',
                                _nameController,
                                'Ex: Nguyen Phu',
                                () {}),
                            title('Gender:'),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: DropdownButtonFormField<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1)),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Male',
                                  'Female'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            title('Birthday:'),
                            BuildTextField(
                                TextInputType.text,
                                true,
                                'Please enter your birthday!',
                                _birthdayController,
                                'Ex: 18/09/2000', () async {
                              final selectedDate =
                                  await _selectDateTime(context);
                              if (selectedDate != null) {
                                setState(() {
                                  this.selectedDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                  );
                                  _birthdayController.text =
                                      formatDate.format(this.selectedDate);
                                });
                              }
                            }),
                            title('Phone Number:'),
                            BuildTextField(
                                TextInputType.number,
                                false,
                                'Please enter your phone number!',
                                _phoneNumberController,
                                'Ex: 0928598741',
                                () {}),
                            title('Address'),
                            BuildTextField(
                                TextInputType.text,
                                true,
                                'Please enter your address!',
                                _addressController,
                                'Ex: Street 11, Long Thanh Ward, District 1, Ho Chi Minh City',
                                () {
                              return showModalBottomSheet(
                                  isScrollControlled: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SheetAddress();
                                  });
                            }),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: TextButton(
                                    onPressed: () async {
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (!_formkey.currentState!
                                            .validate()) {
                                          // Invalid!
                                          return;
                                        }
                                        _formkey.currentState!.save();
                                        final userData = UserItem(
                                          id: widget.isSignUp ? '' : user.id,
                                          email: widget.email,
                                          phoneNumber:
                                              _phoneNumberController.text,
                                          gender: dropdownValue == "Male"
                                              ? true
                                              : false,
                                          address: _addressController.text,
                                          fullName: _nameController.text,
                                          avatar: image,
                                          idUser: userId!,
                                          birthday: _birthdayController.text,
                                        );
                                        final address = Address(
                                            id: '',
                                            idUser: userId,
                                            address: _addressController.text,
                                            fullName: _nameController.text,
                                            phoneNumber:
                                                _phoneNumberController.text,
                                            status: true);
                                        if (widget.isSignUp) {
                                          await Provider.of<Addresses>(context,
                                                  listen: false)
                                              .addAddress(address);
                                          await Provider.of<User>(context,
                                                  listen: false)
                                              .addUser(userData)
                                              .then((value) => Navigator.of(
                                                      context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              Scaffold(
                                                                  body: Stack(
                                                                children: [
                                                                  DrawerScreen(),
                                                                  ProductsOverviewScreen(),
                                                                ],
                                                              )))));
                                        } else {
                                          await Provider.of<User>(context,
                                                  listen: false)
                                              .updateUser(userData)
                                              .then((value) => {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: const Text(
                                                      'Update Profile Success!',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                                    setState(() {
                                                      isLoading = false;
                                                    })
                                                  });
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  )),
                            )
                          ]),
                    ),
                  ),
                ),
        ));
  }
}
