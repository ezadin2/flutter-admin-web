import 'package:ecommerce_admin_panel/common/styles/user_model.dart';
import 'package:ecommerce_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CustomerController extends TBaseController<UserModel> {
  static CustomerController get instance => Get.find();

  final Rx<UserModel> selectedCustomer = UserModel.empty().obs;
  final _customerRepository = Get.put(UserRepository());
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  @override
  bool containsSearchQuery(UserModel item, String query) {
    return item.fullName.toLowerCase().contains(query.toLowerCase()) ||
        item.email.toLowerCase().contains(query.toLowerCase()) ||
        item.phoneNumber.toLowerCase().contains(query.toLowerCase());
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
            (UserModel user) => user.fullName.toLowerCase());
  }

  @override
  Future<List<UserModel>> fetchItems() async {
    try {
      isLoading(true);
      errorMessage('');

      final users = await _customerRepository.getAllUsers();
      if (users.isEmpty) {
        errorMessage('No customers found');
      }

      allItems.assignAll(users);
      filteredItems.assignAll(users);
      return users;
    } catch (e) {
      errorMessage('Failed to load customers: ${e.toString()}');
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return [];
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCustomerDetails(String id) async {
    try {
      isLoading(true);
      final user = await _customerRepository.fetchUserDetails(id);
      selectedCustomer.value = user;
    } catch (e) {
      errorMessage('Failed to load customer details');
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  Future<void> deleteItem(UserModel customer) async {
    try {
      isLoading(true);
      await _customerRepository.deleteUser(customer.id ?? '');
      await fetchItems(); // Refresh the list
      TLoaders.successSnackBar(title: 'Success', message: 'Customer deleted');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }
}