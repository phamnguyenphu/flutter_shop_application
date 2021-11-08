import 'package:flutter/material.dart';

Padding title(String name) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Text(
      name,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Padding BuildTextField(
    TextInputType tyle,
    bool isRead,
    String vali,
    TextEditingController nameController,
    String placeholder,
    Function() handle) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: TextFormField(
        keyboardType: tyle,
        readOnly: isRead,
        onTap: handle,
        controller: nameController,
        validator: (val) => val!.trim().length == 0 ? vali : null,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          fillColor: Colors.black,
          hintText: placeholder,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.black, width: 1)),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
          ),
        ),
      ));
}
