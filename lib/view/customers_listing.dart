import 'package:customer_crud/controller/validation_controller.dart';
import 'package:customer_crud/view/edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CustomerListing extends StatefulWidget {
  const CustomerListing({super.key});

  @override
  State<CustomerListing> createState() => _CustomerListingState();
}

class _CustomerListingState extends State<CustomerListing> {
  final controller = Get.find<ValidationController>();

  @override
  void initState() {
    super.initState();
    controller.fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Listings",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
      ),
      body: Obx(() {
        if (controller.customers.isEmpty) {
          return const Center(child: Text("No customers found."));
        } else {
          return ListView.builder(
            itemCount: controller.customers.length,
            itemBuilder: (context, index) {
              final customer = controller.customers[index];
              debugPrint("pan:${customer['pan']}");
              // controller.loadCustomerDetails(customer);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey)),
                  title: Text(
                    customer['full_name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pan: ${customer['pan']}'),
                      Text('Email: ${customer['phone']}'),
                      Text('+91 ${customer['phone']}'),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.addresses.length,
                            itemBuilder: (context, index) {
                              var address = controller.addresses[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Address Line 1: ${address.addressLine1.text}"),
                                  Text(
                                      "Address Line 2: ${address.addressLine2.text}"),
                                  Text("Postcode: ${address.postcode.text}"),
                                  Text("State: ${address.state.text}"),
                                  Text("City: ${address.city.text}"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Wrap(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.to(
                                      () => EditCustomer(customer: customer));
                                },
                                child: const Icon(Iconsax.edit)),
                            const SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                                onTap: () {
                                  controller.removeCustomer(index);
                                },
                                child: const Icon(Iconsax.trash)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // You can add navigation to customer details here
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}
