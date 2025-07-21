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
    return item.id.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    // await _orderRepository.deleteOrder(item.docId);
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) =>
        o.totalAmount.toString().toLowerCase());
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) =>
        o.orderDate.toString().toLowerCase());
  }

  Future<void> updateOrderStatus(OrderModel order, OrderStatus newStatus) async {
    try {
      statusLoad.value = true;
      debugPrint('Updating order ${order.docId} from ${order.status} to $newStatus');

      // Update local order status first
      order.status = newStatus;

      // Update in repository - now requires userId
      await _orderRepository.updateOrderStatus(
          order.userId, // Make sure your OrderModel has this field
          order.docId,
          newStatus.toString().split('.').last
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

      TLoaders.errorSnackBar(
          title: 'Update Failed',
          message: e.toString().replaceAll('Exception:', '').trim()
      );
    } finally {
      statusLoad.value = false;
    }
  }
  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );
  }

  void sortByProperty(int sortColumnIndex, bool ascending, Function(OrderModel) property) {
    sortAscending.value = ascending;
    this.sortColumnIndex.value = sortColumnIndex;
    filteredItems.sort((a, b) {
      if (ascending) {
        return property(a).compareTo(property(b));
      } else {
        return property(b).compareTo(property(a));
      }
    });
  }
}