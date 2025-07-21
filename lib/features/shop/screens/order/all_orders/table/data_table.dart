import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../order/all_orders/table/table_source.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>(); // Use Get.find instead of Get.put

    return Obx(() {
      // Show loading indicator while data is being fetched
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Show empty state if no orders found
      if (controller.filteredItems.isEmpty) {
        return const Center(child: Text('No orders found'));
      }

      // Debug information (remove in production)
      debugPrint('Total Orders: ${controller.filteredItems.length}');
      debugPrint('Selected Rows: ${controller.selectedRows.where((e) => e).length}');

      return Column(
        children: [
          // Optional: Show counts at the top
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Orders: ${controller.filteredItems.length}'),
                Text('Selected: ${controller.selectedRows.where((e) => e).length}'),
              ],
            ),
          ),

          // The data table
          TPaginatedDataTable(
            minWidth: 700,
            columns: [
              DataColumn2(label: Text('Order ID')),
              DataColumn2(label: Text('Date')),
              DataColumn2(label: Text('Items')),
              DataColumn2(
                label: Text('Status'),
                fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null,
              ),
              DataColumn2(label: Text('Amount')),
              DataColumn2(
                label: Text('Action'),
                fixedWidth: 100,
              ),
            ],
            source: OrderRows(),
          ),
        ],
      );
    });
  }
}