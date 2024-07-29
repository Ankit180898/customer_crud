import 'package:customer_crud/controller/validation_controller.dart';
import 'package:customer_crud/view/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddressFormWidget extends StatelessWidget {
  final ValidationController controller;
  final int index;
  const AddressFormWidget(
      {super.key, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Address - ${index + 1}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),

              // checking to add remove button
              if (index > 0)
                IconButton(
                  icon: const Icon(Iconsax.close_circle, color: Colors.red),
                  onPressed: () => controller.removeAddress(index),
                ),
            ],
          ),
        ),
        InputField(
          icon: Iconsax.location,
          label: "Address Line 1",
          controller: controller.addresses[index].addressLine1,
          validator: (value) =>
          // First address is required
              controller.validator(value!, "Address Line 1 is required"),
        ),
        InputField(
          icon: Iconsax.location,
          label: "Address Line 2",
          controller: controller.addresses[index].addressLine2,
          validator: (value) => null,
        ),
        Obx(() {
          return InputField(
            icon: Iconsax.building,
            label: "Postcode",
            controller: controller.addresses[index].postcode,
            inputType: TextInputType.number,
            inputFormat: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => controller.postcodeValidator(value!),
            onChanged: (value) {
              // getting data from postcode api
              if (controller.postcodeRequirement.hasMatch(value)) {
                controller.getPostcodeDetails(value, index);
              }
            },
            suffixIcon: controller.isLoadingPostcode.value
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
                controller: controller.addresses[index].state,
                validator: (value) =>
                    controller.validator(value!, "State is required"),
              ),
            ),
            Expanded(
              child: InputField(
                icon: Iconsax.building,
                label: "City",
                controller: controller.addresses[index].city,
                validator: (value) =>
                    controller.validator(value!, "City is required"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
