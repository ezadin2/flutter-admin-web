import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/order/order_respository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/order_model.dart';

class OrderController extends TBaseController<OrderModel> {
  static OrderController get instance => Get.find();
  RxBool statusLoad = false.obs;
  final _orderRepository = Get.put(OrderRepository());

  @override
  Future<List<OrderModel>> fetchItems() async {
    try {
      isLoading.value = true;
      final orders = await _orderRepository.getAllOrders();
      allItems.assignAll(orders);
      filteredItems.assignAll(orders);
      return orders;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error fetching orders', message: e.toString());
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) {
    return item.id.toLowerCase().contains(query.toLowerCase()) ||
        item.userId.toLowerCase().contains(query.toLowerCase()) ||
        item.statusDisplayText.toLowerCase().contains(query.toLowerCase()) ||
        item.paymentMethod.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    try {
      isLoading.value = true;
      await _orderRepository.deleteOrder(item.docId);
      allItems.removeWhere((order) => order.docId == item.docId);
      filteredItems.removeWhere((order) => order.docId == item.docId);
      TLoaders.successSnackBar(title: 'Success', message: 'Order deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error deleting order', message: e.toString());
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.id.toLowerCase());
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.orderDate);
  }

  void sortByStatus(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.status.index);
  }

  void sortByAmount(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.totalAmount);
  }

  Future<void> updateOrderStatus(OrderModel order, OrderStatus newStatus) async {
    try {
      statusLoad.value = true;
      debugPrint('Updating order ${order.docId} from ${order.status} to $newStatus');

      // Update local order status first
      order.status = newStatus;

      // Update in repository - now only needs orderId and status
      await _orderRepository.updateOrderStatus(
        order.docId,
        newStatus.toString().split('.').last,
      );

      // Update lists
      updateItemsFromLists(order);

      TLoaders.successSnackBar(
          title: 'Success',
          message: 'Order status updated to ${newStatus.toString().split('.').last}'
      );
    } catch (e, stackTrace) {
      debugPrint('Error updating order status: $e');
      debugPrint('Stack trace: $stackTrace');

      // Revert local change if update failed
      final originalStatus = allItems.firstWhere((o) => o.docId == order.docId).status;
      order.status = originalStatus;
      updateItemsFromLists(order);

      TLoaders.errorSnackBar(
          title: 'Update Failed',
          message: e.toString().replaceAll('Exception:', '').trim()
      );
    } finally {
      statusLoad.value = false;
    }
  }

  void searchQuery(String query) {
    if (query.isEmpty) {
      filteredItems.assignAll(allItems);
      return;
    }

    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );
  }

  void sortByProperty(int sortColumnIndex, bool ascending, Function(OrderModel) property) {
    sortAscending.value = ascending;
    this.sortColumnIndex.value = sortColumnIndex;
    filteredItems.sort((a, b) {
      final aValue = property(a);
      final bValue = property(b);

      if (aValue is DateTime && bValue is DateTime) {
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      }
      if (aValue is num && bValue is num) {
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      }

      final aString = aValue.toString().toLowerCase();
      final bString = bValue.toString().toLowerCase();
      return ascending ? aString.compareTo(bString) : bString.compareTo(aString);
    });
  }

  void updateItemsFromLists(OrderModel updatedOrder) {
    final allItemsIndex = allItems.indexWhere((o) => o.docId == updatedOrder.docId);
    if (allItemsIndex >= 0) {
      allItems[allItemsIndex] = updatedOrder;
    }

    final filteredItemsIndex = filteredItems.indexWhere((o) => o.docId == updatedOrder.docId);
    if (filteredItemsIndex >= 0) {
      filteredItems[filteredItemsIndex] = updatedOrder;
    }
  }
}