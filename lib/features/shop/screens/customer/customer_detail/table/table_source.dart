import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerOrdersRows extends DataTableSource {
  final controller = CustomerDetailController.instance;

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredCustomerOrder[index];
    final items = order.items ?? [];
    final totalAmount = items.fold<double>(
      0,
          (previousValue, element) => previousValue + (element.price ?? 0),
    );

    return DataRow2(
      selected: controller.selectedRows[index],
      onTap: () => Get.toNamed(TRoutes.orderDetails, arguments: order),
      cells: [
        DataCell(Text(
          order.id,
          style: Theme.of(Get.context!)
              .textTheme
              .bodyLarge
              ?.apply(color: TColors.primary),
        )),
        DataCell(Text(order.formattedDeliveryDate)),
        DataCell(Text('${items.length} Items')),
        DataCell(TRoundedContainer(
          radius: TSizes.cardRadiusSm,
          padding: const EdgeInsets.symmetric(
            vertical: TSizes.sm,
            horizontal: TSizes.md,
          ),
          backgroundColor: THelperFunctions.getOrderStatusColor(order.status)
              .withOpacity(0.1),
          child: Text(
            order.status.name.capitalize ?? '',
            style: TextStyle(
              color: THelperFunctions.getOrderStatusColor(order.status),
            ),
          ),
        )),
        DataCell(Text('\$$totalAmount')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredCustomerOrder.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
