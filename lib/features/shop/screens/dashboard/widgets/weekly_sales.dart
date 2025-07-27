// file: sales_graph.dart

import 'package:ecommerce_admin_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

class TSalesGraph extends StatelessWidget {
  final SalesViewType viewType;

  const TSalesGraph({super.key, this.viewType = SalesViewType.weekly, required bool showWeekly});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashBoardController());
    controller.viewType.value = viewType;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TCircularIcon(
                icon: Iconsax.graph,
                backgroundColor: Colors.brown.withOpacity(0.1),
                color: Colors.brown,
                size: TSizes.md,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Obx(() => Text(
                controller.viewType.value == SalesViewType.daily
                    ? 'Daily Sales'
                    : controller.viewType.value == SalesViewType.weekly
                    ? 'Weekly Sales'
                    : 'Monthly Sales',
                style: Theme.of(context).textTheme.headlineSmall,
              )),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          Obx(() {
            final salesData = controller.viewType.value == SalesViewType.daily
                ? controller.dailySales
                : controller.viewType.value == SalesViewType.weekly
                ? controller.weeklySales
                : controller.monthlySales;

            return salesData.isNotEmpty
                ? SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: BarChart(
                  BarChartData(
                    titlesData: buildFlTitlesData(salesData, controller.viewType.value),
                    borderData: FlBorderData(show: true, border: const Border(top: BorderSide.none, right: BorderSide.none)),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      horizontalInterval: _calculateInterval(salesData),
                    ),
                    barGroups: salesData.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value,
                            width: 30,
                            color: TColors.primary,
                            borderRadius: BorderRadius.circular(TSizes.sm),
                          )
                        ],
                      );
                    }).toList(),
                    groupsSpace: TSizes.spaceBtwItems,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(getTooltipColor: (_) => TColors.secondary),
                      touchCallback: TDeviceUtils.isDesktopScreen(context) ? (event, response) {} : null,
                    ),
                  ),
                ),
              ),
            )
                : const SizedBox();
          })
        ],
      ),
    );
  }

  double _calculateInterval(List<double> sales) {
    if (sales.isEmpty) return 100;
    final maxSale = sales.reduce((a, b) => a > b ? a : b);
    if (maxSale <= 1000) return 100;
    if (maxSale <= 5000) return 500;
    if (maxSale <= 10000) return 1000;
    return 2000;
  }

  FlTitlesData buildFlTitlesData(List<double> sales, SalesViewType viewType) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (viewType == SalesViewType.monthly) {
              if (index < 0 || index > 11) return const SizedBox();
              final month = DateFormat('MMM').format(DateTime(0, index + 1));
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(month, style: const TextStyle(fontSize: 10)),
              );
            } else {
              if (index < 0 || index > 6) return const SizedBox();
              final now = DateTime.now();
              final day = now.subtract(Duration(days: 6 - index));
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${day.day}', style: const TextStyle(fontSize: 10)),
              );
            }
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false), // 👈 Hides left Y-axis labels
      ),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

}
