import 'package:ecommerce_admin_panel/features/shop/product/product_images_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/table/data_table.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/dashboard/dashboard_controller.dart';
import '../../../controllers/order/order_controller.dart';
import '../widgets/order_status_pie_chart.dart';
import '../widgets/t_dashboard_card.dart';
import '../widgets/weekly_sales.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashBoardController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Dashboard Cards Row
              Row(
                children: [
                  // Sales Total Card
                  Expanded(
                    child: Obx(
                          () {
                        final currentSales = controller.orderController.allItems.fold(
                            0.0,
                                (sum, element) => sum + element.totalAmount
                        );
                        final previousSales = controller.getPreviousMonthSales();
                        final percentage = controller.calculatePercentageChange(
                            currentSales,
                            previousSales
                        );

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
                      },
                    ),
                  ),

                  SizedBox(width: TSizes.spaceBtwItems),

                  // Average Order Card
                  // In the Average Order Card section
                  Expanded(
                    child: Obx(
                          () {
                        final currentAvg = controller.orderController.allItems.isEmpty ? 0.0 :
                        controller.orderController.allItems.fold(
                            0.0,
                                (sum, element) => sum + element.totalAmount
                        ) / controller.orderController.allItems.length;

                        final previousMonthOrders = controller.orderController.allItems
                            .where((order) {
                          final now = DateTime.now();
                          DateTime previousMonth;
                          if (now.month == 1) {
                            previousMonth = DateTime(now.year - 1, 12);
                          } else {
                            previousMonth = DateTime(now.year, now.month - 1);
                          }
                          return order.orderDate.month == previousMonth.month &&
                              order.orderDate.year == previousMonth.year;
                        })
                            .toList();

                        final previousAvg = previousMonthOrders.isEmpty ? 0.0 :
                        previousMonthOrders.fold(
                            0.0,
                                (sum, element) => sum + element.totalAmount
                        ) / previousMonthOrders.length;

                        final percentage = controller.calculatePercentageChange(
                            currentAvg,
                            previousAvg
                        );

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
                      },
                    ),
                  ),

                  SizedBox(width: TSizes.spaceBtwItems),

                  // Total Orders Card
                  // In the Total Orders Card section
                  Expanded(
                    child: Obx(
                          () {
                        final currentOrders = controller.orderController.allItems.length.toDouble();

                        final previousMonthOrders = controller.orderController.allItems
                            .where((order) {
                          final now = DateTime.now();
                          DateTime previousMonth;
                          if (now.month == 1) {
                            previousMonth = DateTime(now.year - 1, 12);
                          } else {
                            previousMonth = DateTime(now.year, now.month - 1);
                          }
                          return order.orderDate.month == previousMonth.month &&
                              order.orderDate.year == previousMonth.year;
                        })
                            .length.toDouble();

                        final percentage = controller.calculatePercentageChange(
                            currentOrders,
                            previousMonthOrders
                        );

                        return TDashboardCard(
                          headingIcon: Iconsax.box,
                          headingIconColor: Colors.deepPurple,
                          headingIconBgColor: Colors.deepPurple.withOpacity(0.1),
                          title: 'Total Orders',
                          subTitle: '${currentOrders.toInt()}',
                          stats: percentage.round(),
                          previousPeriod: controller.getPreviousMonthName(),
                          isPositive: percentage >= 0,
                        );
                      },
                    ),
                  ),

                  SizedBox(width: TSizes.spaceBtwItems),

                  // Visitors Card
                  // In the Visitors Card section
                  Expanded(
                    child: Obx(
                          () {
                        final currentVisitors = controller.customerController.allItems.length.toDouble();
                        final previousMonthVisitors = (currentVisitors * 0.9).toDouble();

                        final percentage = controller.calculatePercentageChange(
                            currentVisitors,
                            previousMonthVisitors
                        );

                        return TDashboardCard(
                          headingIcon: Iconsax.user,
                          headingIconColor: Colors.deepOrange,
                          headingIconBgColor: Colors.deepOrange.withOpacity(0.1),
                          title: 'Visitors',
                          subTitle: '${currentVisitors.toInt()}',
                          stats: percentage.round(),
                          previousPeriod: controller.getPreviousMonthName(),
                          isPositive: percentage >= 0,
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: TSizes.spaceBtwSections),

              // Graphs Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column (Graph and Orders Table)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Bar Graph
                        TSalesGraph(showWeekly: controller.weeklySales.any((sale) => sale > 80000)),
                        SizedBox(height: TSizes.spaceBtwSections),

                        // Orders Table
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent Orders',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: TSizes.spaceBtwSections),

                  // Right Column (Pie Chart)
                  Expanded(
                    child: TOrderStatusPieChart(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}