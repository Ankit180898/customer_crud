import 'package:customer_crud/controller/validation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CustomerListing extends StatefulWidget {
  const CustomerListing({super.key});

  @override
  State<CustomerListing> createState() => _CustomerListingState();
}

class _CustomerListingState extends State<CustomerListing> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ValidationController>();
    @override
    void initState() {
      super.initState();
      controller.fetchCustomers();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Listings"),
      ),
      body: Obx(() {
        if (controller.customers.isEmpty) {
          return const Center(child: Text("No customers found."));
        } else {
          return ListView.builder(
            itemCount: controller.customers.length,
            itemBuilder: (context, index) {
              final customer = controller.customers[index];
              return ListTile(
                title: Text(
                  customer['full_name'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black),
                ),
                subtitle: Text(customer['email']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          
                        }, icon: const Icon(Iconsax.edit)),
                    IconButton(
                        onPressed: () {
                          controller.removeCustomer(index);
                        },
                        icon: const Icon(Iconsax.trash))
                  ],
                ),
                onTap: () {
                  // You can add navigation to customer details here
                },
              );
            },
          );
        }
      }),
    );
  }
}
