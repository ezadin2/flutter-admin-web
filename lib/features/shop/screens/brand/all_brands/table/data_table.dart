import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/all_brands/table/table_source.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/brand/brand_controller.dart';

class BrandTable extends StatelessWidget {
  const BrandTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    return Obx(() {
      // Debug information can be shown like this if needed
      debugPrint('Items count: ${controller.filteredItems.length}');
      debugPrint('Selected rows: ${controller.selectedRows.where((e) => e).length}');

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredItems.isEmpty) {
        return const Center(child: Text('No brands found'));
      }

      final hasLargeCategories = controller.filteredItems.any(
            (element) => element.brandCategories != null && element.brandCategories!.length > 2,
      );

      return TPaginatedDataTable(
        minWidth: 700,
        tableHeight: hasLargeCategories ? 600 : 400, // Adjusted heights
        dataRowHeight: hasLargeCategories ? 120 : 80, // Reasonable row heights
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(
            label: const Text('Brands'),
            fixedWidth: TDeviceUtils.isMobileScreen(Get.context!) ? null : 200,
            onSort: (columnIndex, ascending) =>
                controller.sortByName(columnIndex, ascending),
          ),
          const DataColumn2(label: Text('Category')),
          DataColumn2(
            label: const Text('Featured'),
            fixedWidth: TDeviceUtils.isMobileScreen(Get.context!) ? null : 100,
          ),
          DataColumn2(
            label: const Text('Date'),
            fixedWidth: TDeviceUtils.isMobileScreen(Get.context!) ? null : 200,
          ),
          DataColumn2(
            label: const Text('Action'),
            fixedWidth: TDeviceUtils.isMobileScreen(Get.context!) ? null : 100,
          ),
        ],
        source: BrandRows(),
      );
    });
  }
}