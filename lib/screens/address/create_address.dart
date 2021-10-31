import 'package:flutter/material.dart';
import 'package:flutter_shop_application/screens/address/map_google.dart';
import 'package:sizer/sizer.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:line_awesome_icons/line_awesome_icons.dart';

class CreateAddress extends StatefulWidget {
  const CreateAddress({Key? key}) : super(key: key);

  @override
  State<CreateAddress> createState() => _CreateAddressState();
}

class _CreateAddressState extends State<CreateAddress> {
  final _formkey = new GlobalKey<FormState>();
  bool defaultStatus = false;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  tapCompleted() {
    if (_formkey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) => Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pink),
                ),
              ),
          barrierColor: Colors.grey.shade100,
          barrierDismissible: false);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Address',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.all(5.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact :',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 11.sp,
                        letterSpacing: 1.0)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 13.sp,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (val) => val!.trim().length == 0
                        ? 'Please enter my name!'
                        : null,
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                          child: new Icon(
                        LineAwesomeIcons.user_secret,
                        color: Colors.blue,
                      )),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                      hintText: 'Ex: Tom Hiddleston',
                      hintStyle: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 13.sp,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (val) => val!.trim().length == 0
                        ? 'Please enter my phone number!'
                        : null,
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                          child: new Icon(
                        LineAwesomeIcons.mobile_phone,
                        color: Colors.purple,
                      )),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                      hintText: 'Ex: 212 823 9800',
                      hintStyle: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text('Address :',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 11.sp,
                        letterSpacing: 1.0)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 13.sp,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (val) => val!.trim().length == 0
                        ? 'Please enter my address!'
                        : null,
                    controller: addressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => MapScreen()));
                        },
                      ),
                      prefixIcon: Container(
                          child: new Icon(
                        LineAwesomeIcons.globe,
                        color: Colors.green,
                      )),
                      fillColor: Colors.white,
                      hintText: 'Ex: 10 Columbus Cir., 4th fl, New York, USA',
                      hintStyle: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text('Settings :',
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 11.sp,
                        letterSpacing: 1.0)),
                SizedBox(height: 0.7.h),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Set as default address',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              letterSpacing: 1.0)),
                    ),
                    Spacer(),
                    Switch(
                        value: defaultStatus,
                        onChanged: (val) {
                          setState(() {
                            defaultStatus = !defaultStatus;
                          });
                        })
                  ],
                ),
                SizedBox(height: 7.h),
                Container(
                  decoration: BoxDecoration(color: Colors.red),
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () => tapCompleted(),
                      child: Text(
                        'Complete',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
