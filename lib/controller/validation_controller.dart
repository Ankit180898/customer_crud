import 'dart:convert';

import 'package:customer_crud/model/address_model.dart';
import 'package:customer_crud/services/database/database_helper.dart';
import 'package:customer_crud/view/customers_listing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ValidationController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final pan = TextEditingController();
  final fullName = TextEditingController().obs;
  final email = TextEditingController();
  final mobile = TextEditingController();

  var isVisible = false.obs;
  var addresses = <Address>[].obs;
  var customers = <Map<String, dynamic>>[].obs;

  final RegExp panRequirement = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
  final RegExp emailRequirement = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp mobileRequirement = RegExp(r'^[0-9]{10}$');
  final RegExp postcodeRequirement = RegExp(r'^[0-9]{6}$');
  var isLoadingPAN = false.obs;
  var isLoadingPostcode = false.obs;
  var name = ''.obs;
  String? validator(String value, String message, {int? maxLength}) {
    if (value.isEmpty) {
      return message;
    } else if (maxLength != null && value.length > maxLength) {
      return 'Maximum length is $maxLength characters';
    } else {
      return null;
    }
  }

  String? panValidator(String value) {
    if (value.isEmpty) {
      return "PAN is required";
    } else if (!panRequirement.hasMatch(value)) {
      return "PAN is not valid";
    } else {
      return null;
    }
  }

  String? emailValidator(String value) {
    if (value.isEmpty) {
      return "Email is required";
    } else if (value.length > 255) {
      return "Email is too long";
    } else if (!emailRequirement.hasMatch(value)) {
      return "Email is not valid";
    } else {
      return null;
    }
  }

  String? mobileValidator(String value) {
    if (value.isEmpty) {
      return "Mobile number is required";
    } else if (!mobileRequirement.hasMatch(value)) {
      return "Mobile number is not valid";
    } else {
      return null;
    }
  }

  String? postcodeValidator(String value) {
    if (value.isEmpty) {
      return "Postcode is required";
    } else if (!postcodeRequirement.hasMatch(value)) {
      return "Postcode is not valid";
    } else {
      return null;
    }
  }

  void addAddress() {
    if (addresses.length < 10) {
      addresses.add(Address(
        addressLine1: TextEditingController(),
        addressLine2: TextEditingController(),
        postcode: TextEditingController(),
        state: TextEditingController(),
        city: TextEditingController(),
      ));
    } else {
      Get.snackbar("Error", "You can only add up to 10 addresses");
    }
  }

  void removeAddress(int index) {
    if (addresses.length != 1) {
      addresses.removeAt(index);
    }
  }

  void showHidePassword() {
    isVisible.value = !isVisible.value;
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }

  Future<void> verifyPAN(String pan) async {
    isLoadingPAN.value = true;
    final response = await http.post(
      Uri.parse('https://lab.pixel6.co/api/verify-pan.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"panNumber": pan}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'Success' && data['isValid'] == true) {
        fullName.value.text = data['fullName'];
      } else {
        showSnackBar('Invalid PAN number', Get.context!);
      }
    } else {
      showSnackBar('Failed to verify PAN', Get.context!);
    }
    isLoadingPAN.value = false;
  }

  Future<void> getPostcodeDetails(String postcode, int addressIndex) async {
    isLoadingPostcode.value = true;
    final response = await http.post(
      Uri.parse('https://lab.pixel6.co/api/get-postcode-details.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"postcode": postcode}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'Success') {
        addresses[addressIndex].state.text = data['state'][0]['name'];
        addresses[addressIndex].city.text = data['city'][0]['name'];
      } else {
        showSnackBar('Invalid postcode', Get.context!);
        isLoadingPostcode.value = false;
      }
    } else {
      showSnackBar('Failed to fetch postcode details', Get.context!);
      isLoadingPostcode.value = false;
    }
    isLoadingPostcode.value = false;
  }

  Future<void> saveCustomerDetails(BuildContext context) async {
    try {
      // Insert customer
      int customerId = await databaseHelper.insertCustomer({
        'pan': pan.value.text,
        'full_name': fullName.value.text,
        'email': email.value.text,
        'phone': mobile.value.text,
      });

      // Insert addresses
      for (var address in addresses) {
        await databaseHelper.insertAddress({
          'customer_id': customerId,
          'address_line1': address.addressLine1.text,
          'address_line2': address.addressLine2.text,
          'postcode': address.postcode.text,
          'state': address.state.text,
          'city': address.city.text,
        });
      }

      showSnackBar("Customer details saved successfully", Get.context!);
      // Navigate to Customer List Page
      Get.off(const CustomerListing());
    } catch (e) {
      showSnackBar("Error saving customer details: $e", Get.context!);
    }
  }

  Future<void> fetchCustomers() async {
    try {
      var customersList = await databaseHelper.getCustomers();
      customers.assignAll(customersList);
    } catch (e) {
      debugPrint("Error fetching customers: $e");
    }
  }


  Future<void> removeCustomer(int index) async {
    try {
      var customer = customers[index];
      await databaseHelper.deleteCustomer(customer['id']);
      customers.removeAt(index);
    } catch (e) {
      debugPrint("Error removing customer: $e");
    }
  }

  Future<void> loadCustomerDetails(Map<String, dynamic> customer) async {
    pan.text = customer['pan'];
    fullName.value.text = customer['full_name'];
    email.text = customer['email'];
    mobile.text = customer['phone'];

    // Load addresses for the customer
    addresses.assignAll((await databaseHelper.getAddresses(customer['id']))
        as Iterable<Address>);
  }

  @override
  void dispose() {
    pan.dispose();
    email.dispose();
    mobile.dispose();
    databaseHelper.close();
    super.dispose();
  }
}
