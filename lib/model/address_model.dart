import 'package:flutter/material.dart';

class Address {
  final TextEditingController addressLine1;
  final TextEditingController addressLine2;
  final TextEditingController postcode;
  final TextEditingController state;
  final TextEditingController city;

  Address({
    required this.addressLine1,
    required this.addressLine2,
    required this.postcode,
    required this.state,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressLine1: TextEditingController(text: json['address_line1']),
      addressLine2: TextEditingController(text: json['address_line2']),
      postcode: TextEditingController(text: json['postcode']),
      state: TextEditingController(text: json['state']),
      city: TextEditingController(text: json['city']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_line1': addressLine1.text,
      'address_line2': addressLine2.text,
      'postcode': postcode.text,
      'state': state.text,
      'city': city.text,
    };
  }
}
