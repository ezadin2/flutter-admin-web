import 'package:ecommerce_admin_panel/common/styles/user_model.dart';
import 'package:ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/AddressRepository/address_repository.dart';

class CustomerDetailController extends GetxController {
  static CustomerDetailController get instance => Get.find();

  RxBool orderLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;
  Rx<UserModel> customer = UserModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());
  final searchTextController = TextEditingController();
  RxList<OrderModel> allCustomerOrder = <OrderModel>[].obs;
  RxList<OrderModel> filteredCustomerOrder = <OrderModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    // Initialize when controller is created
    initializeCustomerData();
  }

  Future<void> initializeCustomerData() async {
    await getCostumerOrders();
    await getCostumerAddress();
  }

  Future<void> getCostumerOrders() async {
    try {
      orderLoading.value = true;
      allCustomerOrder.clear();
      filteredCustomerOrder.clear();

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        final orders = await UserRepository.instance.fetchUserOrders(customer.value.id!);
        allCustomerOrder.assignAll(orders?.cast<OrderModel>() ?? <OrderModel>[]);
        filteredCustomerOrder.assignAll(allCustomerOrder);

        // Initialize selected rows
        selectedRows.assignAll(List.filled(allCustomerOrder.length, false));
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      orderLoading.value = false;
    }
  }



  Future<void> getCostumerAddress() async {
    try {
      addressesLoading.value = true; // Changed from orderLoading

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        final addresses = await addressRepository.fetchUserAddresses(customer.value.id!);
        customer.update((val) {
          val?.addresses = addresses;
        });
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'sorry', message: e.toString());
    } finally {
      addressesLoading.value = false;
    }
  }

  void searchQuery(String query) {
    if (query.isEmpty) {
      filteredCustomerOrder.assignAll(allCustomerOrder);
      return;
    }

    final lowerQuery = query.toLowerCase();
    filteredCustomerOrder.assignAll(allCustomerOrder.where((order) {
      return order.id.toLowerCase().contains(lowerQuery) ||
          order.orderDate.toString().toLowerCase().contains(lowerQuery);
    }));
    update();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredCustomerOrder.sort((a, b) {
      if (ascending) {
        return a.id.toLowerCase().compareTo(b.id.toLowerCase());
      } else {
        return b.id.toLowerCase().compareTo(a.id.toLowerCase());
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;
    update();
  }
}