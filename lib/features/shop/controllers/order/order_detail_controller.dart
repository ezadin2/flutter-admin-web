import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../common/styles/user_model.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../authentication/models/address_model.dart';
import '../../models/order_model.dart';

// order_detail_controller.dart
class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();

  RxBool loading = true.obs;
  Rx<OrderModel> order = OrderModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;
  RxList<AddressModel> userAddresses = <AddressModel>[].obs;
  Rx<AddressModel?> shippingAddress = Rx<AddressModel?>(null);
  Rx<AddressModel?> billingAddress = Rx<AddressModel?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(order, (OrderModel newOrder) {
      if (newOrder.userId.isNotEmpty) {
        getCustomerOfCurrentOrder();
      }
    });
  }

  Future<void> getCustomerOfCurrentOrder() async {
    try {
      loading.value = true;
      customer.value = UserModel.empty();
      userAddresses.clear();
      shippingAddress.value = null;
      billingAddress.value = null;

      if (order.value.userId.isEmpty) return;

      // Fetch user details
      final user = await UserRepository.instance.fetchUserDetails(order.value.userId);
      customer.value = user;

      // Fetch user addresses
      final addresses = await UserRepository.instance.fetchUserAddresses(order.value.userId);
      userAddresses.assignAll(addresses);

      // Determine shipping and billing addresses
      _determineAddresses();
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  void _determineAddresses() {
    // If order already has addresses (from old data structure), use those
    if (order.value.shippingAddress != null) {
      shippingAddress.value = order.value.shippingAddress;
    }
    if (order.value.billingAddress != null) {
      billingAddress.value = order.value.billingAddress;
    }

    // If no addresses in order, try to find them in user's addresses
    if (shippingAddress.value == null) {
      shippingAddress.value = userAddresses.firstWhereOrNull(
            (address) => address.selectedAddress,
      );
    }

    if (billingAddress.value == null) {
      if (order.value.billingAddressSameAsShipping) {
        billingAddress.value = shippingAddress.value;
      } else {
        billingAddress.value = userAddresses.firstWhereOrNull(
              (address) => address.id != shippingAddress.value?.id,
        );
      }
    }
  }
}