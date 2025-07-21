import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/all_products/table/table_source.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Obx(() {
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );
      return TPaginatedDataTable(
        minWidth: 700,
        tableHeight: 900,
        dataRowHeight: 110,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(
            label: Text('Products'),
            fixedWidth: !TDeviceUtils.isDesktopScreen(context) ? 200 : 300,
            onSort: (columnIndex, ascending) =>
                controller.sortByName(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Stock'),
            onSort: (columnIndex, ascending) =>
                controller.sortByStock(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Sold'),
            onSort: (columnIndex, ascending) =>
                controller.sortBySoldItems(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Brand'),
          ),
          DataColumn2(
            label: Text('Price'),
            onSort: (columnIndex, ascending) =>
                controller.sortByPrice(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Date'),
          ),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: ProductsRows(),
      );
    });
  }
}
