import 'package:ecommerce_admin_panel/features/shop/product/product_images_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/table/data_table.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/dashboard/dashboard_controller.dart';
import '../widgets/order_status_pie_chart.dart';
import '../widgets/t_dashboard_card.dart';
import '../widgets/weekly_sales.dart';

class DashboardMobileScreen extends StatelessWidget {
  const DashboardMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashBoardController());

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Title
            Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Dashboard Cards (Stacked)
            Obx(() {
              final currentSales = controller.orderController.allItems.fold(
                  0.0, (sum, element) => sum + element.totalAmount);
              final previousSales = controller.getPreviousMonthSales();
              final percentage = controller.calculatePercentageChange(currentSales, previousSales);
              return TDashboardCard(
                headingIcon: Iconsax.note,
                headingIconColor: Colors.blue,
                headingIconBgColor: Colors.blue.withOpacity(0.1),
                title: 'Sales total',
                subTitle: '\$${currentSales.toStringAsFixed(2)}',
                stats: percentage.round(),
                previousPeriod: controller.getPreviousMonthName(),
                isPositive: percentage >= 0,
              );
            }),
            const SizedBox(height: TSizes.spaceBtwItems),

            Obx(() {
              final currentAvg = controller.orderController.allItems.isEmpty
                  ? 0.0
                  : controller.orderController.allItems.fold(
                  0.0, (sum, e) => sum + e.totalAmount) /
                  controller.orderController.allItems.length;

              final previousOrders = controller.orderController.allItems.where((order) {
                final now = DateTime.now();
                final prevMonth = now.month == 1
                    ? DateTime(now.year - 1, 12)
                    : DateTime(now.year, now.month - 1);
                return order.orderDate.month == prevMonth.month &&
                    order.orderDate.year == prevMonth.year;
              }).toList();

              final previousAvg = previousOrders.isEmpty
                  ? 0.0
                  : previousOrders.fold(0.0, (sum, e) => sum + e.totalAmount) /
                  previousOrders.length;

              final percentage = controller.calculatePercentageChange(currentAvg, previousAvg);

              return TDashboardCard(
                headingIcon: Iconsax.external_drive,
                headingIconColor: Colors.green,
                headingIconBgColor: Colors.green.withOpacity(0.1),
                title: 'Average Order',
                subTitle: '\$${currentAvg.toStringAsFixed(2)}',
                stats: percentage.round(),
                previousPeriod: controller.getPreviousMonthName(),
                isPositive: percentage >= 0,
              );
            }),
            const SizedBox(height: TSizes.spaceBtwItems),

            Obx(() {
              final currentOrders = controller.orderController.allItems.length;

              final previousOrders = controller.orderController.allItems.where((order) {
                final now = DateTime.now();
                final prevMonth = now.month == 1
                    ? DateTime(now.year - 1, 12)
                    : DateTime(now.year, now.month - 1);
                return order.orderDate.month == prevMonth.month &&
                    order.orderDate.year == prevMonth.year;
              }).length;

              final percentage = controller.calculatePercentageChange(
                  currentOrders.toDouble(), previousOrders.toDouble());

              return TDashboardCard(
                headingIcon: Iconsax.box,
                headingIconColor: Colors.deepPurple,
                headingIconBgColor: Colors.deepPurple.withOpacity(0.1),
                title: 'Total Orders',
                subTitle: '$currentOrders',
                stats: percentage.round(),
                previousPeriod: controller.getPreviousMonthName(),
                isPositive: percentage >= 0,
              );
            }),
            const SizedBox(height: TSizes.spaceBtwItems),

            Obx(() {
              final currentVisitors = controller.customerController.allItems.length;
              final previousVisitors = (currentVisitors * 0.9).round(); // Dummy

              final percentage = controller.calculatePercentageChange(
                  currentVisitors.toDouble(), previousVisitors.toDouble());

              return TDashboardCard(
                headingIcon: Iconsax.user,
                headingIconColor: Colors.deepOrange,
                headingIconBgColor: Colors.deepOrange.withOpacity(0.1),
                title: 'Visitors',
                subTitle: '$currentVisitors',
                stats: percentage.round(),
                previousPeriod: controller.getPreviousMonthName(),
                isPositive: percentage >= 0,
              );
            }),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Weekly Sales Graph
            TSalesGraph(showWeekly: controller.weeklySales.any((s) => s > 0)),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Recent Orders Table
            TRoundedContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Orders', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const DashboardOrderTable(),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Order Status Pie Chart
            const TOrderStatusPieChart(),
          ],
        ),
      ),
    );
  }
}
