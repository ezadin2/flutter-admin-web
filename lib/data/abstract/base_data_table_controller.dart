import 'package:ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/shop/models/category_model.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/popups/loaders.dart';

abstract class TBaseController<T> extends GetxController {
  RxBool isLoading = false.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<T> allItems = <T>[].obs;
  RxList<T> filteredItems = <T>[].obs;
  RxList<bool> selectedRows = <bool>[].obs;
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> deleteItem(T item);
  bool containsSearchQuery(T item, String query);
  Future<List<T>> fetchItems();

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      List<T> fetchedItems = [];
      if(allItems.isEmpty){
        fetchedItems = await fetchItems();
      }
      allItems.assignAll(fetchedItems);
      filteredItems.assignAll(allItems);
      selectedRows.assignAll(List.generate(allItems.length, (_) => false));
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh sorry', message: e.toString());
      allItems.assignAll([]);
      filteredItems.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );
  }

  void sortByProperty(int sortColumnIndex, bool ascending, Function(T) property) {
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

  void addItemToLists(T item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
  }

  void updateItemsFromLists(T item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredIndex = filteredItems.indexWhere((i) => i == item);

    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredIndex != -1) filteredItems[filteredIndex] = item;
    filteredItems.refresh();
  }

  void removeItemFromList(T item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));
  }

  Future<void> confirmAndDeleteItem(T item) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (result == true) {
      await deleteOnConfirm(item);
    }
  }

  Future<void> deleteOnConfirm(T item) async {
    try {
      TFullScreenLoader.popUpCircular();
      await deleteItem(item);
      removeItemFromList(item);
      TLoaders.successSnackBar(
          title: 'Item Deleted',
          message: 'Your item has been deleted successfully'
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }
}