import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/customer/customer_detail/table/table_source.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerOrderTable extends StatelessWidget {
  const CustomerOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;

    return Obx(() {
      // Optional: hidden debug values (can be removed in production)
      Visibility(visible: false, child: Text(controller.filteredCustomerOrder.length.toString()));
      Visibility(visible: false, child: Text(controller.selectedRows.length.toString()));

      return TPaginatedDataTable(
        minWidth: 550,
        tableHeight: 640,
        dataRowHeight: kMinInteractiveDimension,
        columns: [
          DataColumn2(
            label: const Text('Order ID'),
            onSort: (columnIndex, ascending) => controller.sortById(columnIndex, ascending),
          ),
          const DataColumn2(label: Text('Date')),
          const DataColumn2(label: Text('Items')),
          DataColumn2(
            label: const Text('Status'),
            fixedWidth: TDeviceUtils.isMobileScreen(context) ? 100 : null,
          ),
          const DataColumn2(label: Text('Amount'), numeric: true),
        ],
        source: CustomerOrdersRows(),
      );
    });
  }
}
