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

  // Named constructor to create an Address object from a JSON map
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressLine1: TextEditingController(text: json['addressLine1']),
      addressLine2: TextEditingController(text: json['addressLine2']),
      postcode: TextEditingController(text: json['postcode']),
      state: TextEditingController(text: json['state']),
      city: TextEditingController(text: json['city']),
    );
  }

  // Method to convert an Address object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1.text,
      'addressLine2': addressLine2.text,
      'postcode': postcode.text,
      'state': state.text,
      'city': city.text,
    };
  }
}
