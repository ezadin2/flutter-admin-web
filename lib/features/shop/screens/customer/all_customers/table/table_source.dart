import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/styles/user_model.dart';

class CustomerRows extends DataTableSource {
  final controller = CustomerController.instance;

  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length) return null;

    final customer = controller.filteredItems[index];

    return DataRow2(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      onTap: () => Get.toNamed(
          TRoutes.customerDetails,
          arguments: customer,
          parameters: {'customerId': customer.id ?? ''}
      ),
      cells: [
        // In CustomerRows class:
        DataCell(Row(
          children: [
            TRoundedImage(
              image: customer.profilePicture ?? TImages.user, // Changed from customer.image
              width: 50,
              height: 50,
              borderRadius: 30,
              fit: BoxFit.cover,
              imageType: ImageType.network,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(customer.fullName)),
          ],
        )),
        DataCell(Text(customer.email)),
        DataCell(Text(customer.formattedPhoneNo)),
        DataCell(Text(customer.formattedDate)),
        DataCell(TTableActionButtons(
          view: true,
          edit: false,
          onViewPressed: () =>
              Get.toNamed(TRoutes.customerDetails, arguments: customer,parameters: {'CustomerId':customer.id ?? ''}),
          onDeletePressed: () =>controller.confirmAndDeleteItem(customer),
        ))
      ],
    );
  }

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
