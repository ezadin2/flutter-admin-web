import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/styles/user_model.dart';
import 'delivary_boy_controller.dart';

class DeliveryListScreen extends StatelessWidget {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final deliveryController = Get.put(DeliveryController());

    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.loadDeliveryBoys();
    });

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Boy List',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Delivery Boys List using Obx
          Obx(() {
            if (userController.loading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userController.deliveryBoys.isEmpty) {
              return const Center(child: Text('No delivery boys found'));
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userController.deliveryBoys.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final boy = userController.deliveryBoys[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      boy.firstName.isNotEmpty
                          ? boy.firstName.substring(0, 1).toUpperCase()
                          : 'D',
                    ),
                  ),
                  title: Text(boy.fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(boy.email),
                      if (boy.phoneNumber.isNotEmpty)
                        Text(boy.formattedPhoneNo),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Iconsax.edit, size: 20),
                        onPressed: () => _editDeliveryBoy(deliveryController, boy),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
                        onPressed: () => _deleteDeliveryBoy(context, boy.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  void _editDeliveryBoy(DeliveryController controller, UserModel boy) {
    controller.isEditing.value = true;
    controller.currentUserId.value = boy.id!;
    controller.firstName.text = boy.firstName;
    controller.lastName.text = boy.lastName;
    controller.email.text = boy.email;
    controller.phone.text = boy.phoneNumber;
  }
  void _deleteDeliveryBoy(BuildContext context, String id) {
    final userController = Get.find<UserController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this delivery boy?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await userController.deleteDeliveryBoy(id);
              userController.loadDeliveryBoys(); // Refresh the list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}