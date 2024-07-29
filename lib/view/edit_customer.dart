import 'package:customer_crud/controller/validation_controller.dart';
import 'package:customer_crud/view/components/address_form_widget.dart';
import 'package:customer_crud/view/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditCustomer extends StatefulWidget {
  final Map<String, dynamic> customer;
  const EditCustomer({required this.customer, super.key});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final controller = Get.put(ValidationController());

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    controller.loadCustomerDetails(widget.customer); // Pre-load customer data

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Customer",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your input fields here, similar to AddCustomer
                Obx(() {
                  return InputField(
                    icon: Iconsax.card,
                    label: "PAN",
                    controller: controller.pan,
                    validator: (value) => controller.panValidator(value!),
                    onChanged: (value) {
                      if (controller.panRequirement.hasMatch(value)) {
                        controller.verifyPAN(value);
                      }
                    },
                    suffixIcon: controller.isLoadingPAN.value
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 5,
                              width: 5,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            ),
                          )
                        : null,
                  );
                }),
                Obx(() {
                  return InputField(
                    icon: Iconsax.user,
                    label: "Full Name",
                    controller: controller.fullName.value,
                    validator: (value) =>
                        controller.validator(value!, "Full Name is required"),
                  );
                }),
                InputField(
                  icon: Iconsax.sms,
                  label: "Email",
                  controller: controller.email,
                  validator: (value) => controller.emailValidator(value!),
                ),
                InputField(
                  prefixText: "+91 ",
                  label: "Mobile Number",
                  controller: controller.mobile,
                  inputType: TextInputType.phone,
                  inputFormat: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => controller.mobileValidator(value!),
                ),
                Obx(() {
                  return SizedBox(
                    child: Column(
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.addresses.length,
                          itemBuilder: (context, index) {
                            return AddressFormWidget(
                              index: index,
                              controller: controller,
                            );
                          },
                        ),
                        TextButton(
                          onPressed: controller.addAddress,
                          child: const Row(
                            children: [
                              Icon(Iconsax.add),
                              Text(" Add Address"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: RawMaterialButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.lightBlueAccent,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          controller.updateCustomerDetails(context,widget.customer['id']);
                        } else {
                          controller.showSnackBar("Fix the error", context);
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
