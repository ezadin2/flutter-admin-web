import 'package:ecommerce_admin_panel/common/widgets/containers/circular_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TOrderStatusPieChart extends StatelessWidget {
  const TOrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashBoardController.instance;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Row(
            children: [
              TCircularIcon(
                icon: Iconsax.status,
                backgroundColor: Colors.amber.withOpacity(0.1),
                color: Colors.amber,
                size: TSizes.md,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(
                'Order Status',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          /// Pie Chart
          Obx(
                () => controller.orderStatusData.isNotEmpty
                ? SizedBox(
              height: 400,
              child: PieChart(
                PieChartData(
                  sections: controller.orderStatusData.entries.map((entry) {
                    final status = entry.key;
                    final count = entry.value;
                    return PieChartSectionData(
                      title: count.toString(),
                      value: count.toDouble(),
                      radius: 100,
                      color: THelperFunctions.getOrderStatusColor(status),
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {},
                    enabled: true,
                  ),
                ),
              ),
            )
                : const SizedBox(
              height: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [TLoaderAnimation()],
              ),
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          /// Data Table
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Orders')),
                DataColumn(label: Text('Total')),
              ],
              rows: controller.orderStatusData.entries.map((entry) {
                final OrderStatus status = entry.key;
                final int count = entry.value;
                final totalAmount = controller.totalAmounts[status] ?? 0;

                return DataRow(cells: [
                  DataCell(
                    Row(
                      children: [
                        TCircularContainer(
                          width: 20,
                          height: 20,
                          backgroundColor: THelperFunctions.getOrderStatusColor(status),
                        ),
                        const SizedBox(width: TSizes.sm),
                        Expanded(
                          child: Text(
                            controller.getDisplayStatusStringName(status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(count.toString())),
                  DataCell(Text(totalAmount.toStringAsFixed(2))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
