import 'package:customer_crud/controller/validation_controller.dart';
import 'package:customer_crud/view/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddCustomer extends StatelessWidget {
  AddCustomer({super.key});

  final controller = Get.put(ValidationController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (controller.addresses.isEmpty) {
      controller.addAddress();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Form validation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: Text(
                    "Add Customer Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
                Obx(() {
                  return InputField(
                    icon: Iconsax.card,
                    label: "PAN",
                    controller: controller.pan,
                    validator: (value) => controller.panValidator(value!),
                    onChanged: (value) {
                      // verify pan if the pan format is matched
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
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Address - ${index + 1}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      if (controller.addresses.length > 1)
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              controller.removeAddress(index),
                                        ),
                                    ],
                                  ),
                                ),
                                InputField(
                                  icon: Iconsax.location,
                                  label: "Address Line 1",
                                  controller:
                                      controller.addresses[index].addressLine1,
                                  validator: (value) => controller.validator(
                                      value!, "Address Line 1 is required"),
                                ),
                                InputField(
                                  icon: Iconsax.location,
                                  label: "Address Line 2",
                                  controller:
                                      controller.addresses[index].addressLine2,
                                  validator: (value) => null,
                                ),
                                Obx(() {
                                  return InputField(
                                    icon: Iconsax.building,
                                    label: "Postcode",
                                    controller:
                                        controller.addresses[index].postcode,
                                    inputType: TextInputType.number,
                                    inputFormat: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) =>
                                        controller.postcodeValidator(value!),
                                    onChanged: (value) {
                                      if (controller.postcodeRequirement
                                          .hasMatch(value)) {
                                        controller.getPostcodeDetails(
                                            value, index);
                                      }
                                    },
                                    suffixIcon: controller
                                            .isLoadingPostcode.value
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: InputField(
                                        icon: Iconsax.map,
                                        label: "State",
                                        controller:
                                            controller.addresses[index].state,
                                        validator: (value) =>
                                            controller.validator(
                                                value!, "State is required"),
                                      ),
                                    ),
                                    Expanded(
                                      child: InputField(
                                        icon: Iconsax.building,
                                        label: "City",
                                        controller:
                                            controller.addresses[index].city,
                                        validator: (value) =>
                                            controller.validator(
                                                value!, "City is required"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12.0),
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
                          debugPrint("noice");
                          // navigate to the success screen
                        } else {
                          controller.showSnackBar("Fix the error", context);
                        }
                      },
                      child: const Text(
                        'Submit',
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
