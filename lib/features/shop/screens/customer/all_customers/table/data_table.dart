import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/table/table_source.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/customer/all_customers/table/table_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerController.instance;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }

      if (controller.filteredItems.isEmpty) {
        return const Center(child: Text('No customers found'));
      }

      return TPaginatedDataTable(
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(
            label: const Text('Customer'),
            onSort: controller.sortByName,
          ),
          const DataColumn2(label: Text('Email')),
          const DataColumn2(label: Text('Phone')),
          const DataColumn2(label: Text('Registered')),
          const DataColumn2(label: Text('Actions'), fixedWidth: 120),
        ],
        source: CustomerRows(),
      );
    });
  }
}
