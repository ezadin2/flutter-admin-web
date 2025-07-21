import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/table/table_source.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/order/all_orders/table/table_source.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return TPaginatedDataTable(
      minWidth: 700,
        columns: [
          DataColumn2(label: Text('Order ID')),
          DataColumn2(label: Text('Date')),
          DataColumn2(label: Text('items')),
          DataColumn2(label: Text('status'),fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 :null),
          DataColumn2(label: Text('amount')),
          DataColumn2(label: Text('action'),fixedWidth: 100),
        ],
        source: OrderRows(),

    );
  }
}
