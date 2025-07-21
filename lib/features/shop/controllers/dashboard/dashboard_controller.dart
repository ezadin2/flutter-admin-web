// file: dashboard_controller.dart

import 'package:ecommerce_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../models/order_model.dart';
import '../order/order_controller.dart';

enum SalesViewType { daily, weekly, monthly }

class DashBoardController extends TBaseController<OrderModel> {
  static DashBoardController get instance => Get.find();
  final orderController = Get.put(OrderController());
  final customerController = Get.put(CustomerController());

  final Rx<SalesViewType> viewType = SalesViewType.weekly.obs;
  final RxList<double> dailySales = <double>[].obs;
  final RxList<double> weeklySales = <double>[].obs;
  final RxList<double> monthlySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  @override
  Future<List<OrderModel>> fetchItems() async {
    if (orderController.allItems.isEmpty) {
      await orderController.fetchItems();
    }
    if (customerController.allItems.isEmpty) {
      await customerController.fetchItems();
    }

    _calculateWeeklySales();
    _calculateDailySales();
    _calculateMonthlySales();
    _calculateOrderStatusData();

    return orderController.allItems;
  }

  void _calculateDailySales() {
    dailySales.value = List<double>.filled(7, 0.0);
    final DateTime now = DateTime.now();

    for (var order in orderController.allItems) {
      final DateTime orderDate = order.orderDate;
      final int daysAgo = now.difference(orderDate).inDays;

      if (daysAgo >= 0 && daysAgo < 7) {
        dailySales[6 - daysAgo] += order.totalAmount;
      }
    }
  }

  void _calculateWeeklySales() {
    weeklySales.value = List<double>.filled(7, 0.0);

    for (var order in orderController.allItems) {
      final DateTime orderWeekStart = THelperFunctions.getStartOfWeek(order.orderDate);

      if (orderWeekStart.isBefore(DateTime.now()) &&
          orderWeekStart.add(Duration(days: 7)).isAfter(DateTime.now())) {
        int index = (order.orderDate.weekday - 1) % 7;
        weeklySales[index] += order.totalAmount;
      }
    }
  }

  void _calculateMonthlySales() {
    monthlySales.value = List<double>.filled(12, 0.0);

    for (var order in orderController.allItems) {
      final int monthIndex = order.orderDate.month - 1;
      monthlySales[monthIndex] += order.totalAmount;
    }
  }

  void _calculateOrderStatusData() {
    orderStatusData.clear();
    totalAmounts.value = {for (var status in OrderStatus.values) status: 0.0};
    for (var order in orderController.allItems) {
      final status = order.status;
      orderStatusData[status] = (orderStatusData[status] ?? 0) + 1;
      totalAmounts[status] = (totalAmounts[status] ?? 0) + order.totalAmount;
    }
  }

  String getDisplayStatusStringName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  double calculatePercentageChange(double current, double previous) {
    if (previous == 0) return current == 0 ? 0 : 100;
    return ((current - previous) / previous) * 100;
  }

  double getCurrentMonthSales() {
    final now = DateTime.now();
    return orderController.allItems.fold(0.0, (sum, order) {
      if (order.orderDate.month == now.month && order.orderDate.year == now.year) {
        return sum + order.totalAmount;
      }
      return sum;
    });
  }

  double getPreviousMonthSales() {
    final now = DateTime.now();
    final previousMonth = now.month == 1 ? DateTime(now.year - 1, 12) : DateTime(now.year, now.month - 1);
    return orderController.allItems.fold(0.0, (sum, order) {
      if (order.orderDate.month == previousMonth.month && order.orderDate.year == previousMonth.year) {
        return sum + order.totalAmount;
      }
      return sum;
    });
  }

  String getCurrentMonthName() => DateFormat('MMMM').format(DateTime.now());

  String getPreviousMonthName() {
    final now = DateTime.now();
    final previousMonth = now.month == 1 ? DateTime(now.year - 1, 12) : DateTime(now.year, now.month - 1);
    return DateFormat('MMMM yyyy').format(previousMonth);
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) => false;

  @override
  Future<void> deleteItem(OrderModel item) async {}
}