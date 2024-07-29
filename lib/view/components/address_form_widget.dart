import 'package:customer_crud/view/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controller/validation_controller.dart';

class AddressFormItemWidget extends StatefulWidget {
  final int index;
  final GlobalKey<FormState> formKey;
  final Function onRemove;

  const AddressFormItemWidget(
      {required this.index, required this.onRemove, super.key, required this.formKey});

  @override
  State<StatefulWidget> createState() => _AddressFormItemWidgetState();
}

class _AddressFormItemWidgetState extends State<AddressFormItemWidget> {
  final formKey = GlobalKey<FormState>();
  final ValidationController controller = Get.find<ValidationController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Address - ${widget.index + 1}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
                if (controller.addresses.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => widget.onRemove(),
                  ),
              ],
            ),
          ),
          InputField(
            icon: Iconsax.location,
            label: "Address Line 1",
            controller: controller.addresses[widget.index].addressLine1,
            validator: (value) =>
                controller.validator(value!, "Address Line 1 is required"),
          ),
          InputField(
            icon: Iconsax.location,
            label: "Address Line 2",
            controller: controller.addresses[widget.index].addressLine2,
            validator: (value) => null,
          ),
          Obx(() {
            return InputField(
              icon: Iconsax.building,
              label: "Postcode",
              controller: controller.addresses[widget.index].postcode,
              inputType: TextInputType.number,
              inputFormat: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => controller.postcodeValidator(value!),
              onChanged: (value) {
                if (controller.postcodeRequirement.hasMatch(value)) {
                  controller.getPostcodeDetails(value, widget.index);
                }
              },
              suffixIcon: controller.isLoadingPostcode.value
                  ? const CircularProgressIndicator()
                  : null,
            );
          }),
          Row(
            children: [
              Expanded(
                child: InputField(
                  icon: Iconsax.map,
                  label: "State",
                  controller: controller.addresses[widget.index].state,
                  validator: (value) =>
                      controller.validator(value!, "State is required"),
                ),
              ),
              Expanded(
                child: InputField(
                  icon: Iconsax.building,
                  label: "City",
                  controller: controller.addresses[widget.index].city,
                  validator: (value) =>
                      controller.validator(value!, "City is required"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
