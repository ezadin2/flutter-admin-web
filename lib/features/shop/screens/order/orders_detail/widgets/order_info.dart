import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    return TRoundedContainer(
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date'),
                    Text(
                      '${order.formattedOrderDate}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('Items'),
                    Text(
                      '${order.items?.length} items',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status'),
                    Obx(() {
                      if (controller.statusLoad.value) {
                        return TShimmerEffect(width: double.infinity, height: 55);
                      }

                      final currentStatus = order.status;
                      final statusColor = THelperFunctions.getOrderStatusColor(currentStatus);

                      return TRoundedContainer(
                        radius: TSizes.cardRadiusSm,
                        padding: EdgeInsets.symmetric(
                            horizontal: TSizes.sm, vertical: 0),
                        backgroundColor: statusColor.withOpacity(0.1),
                        child: DropdownButton<OrderStatus>(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          value: currentStatus,
                          onChanged: (OrderStatus? newValue) {
                            if (newValue != null && newValue != currentStatus) {
                              controller.updateOrderStatus(order, newValue);
                            }
                          },
                          items: OrderStatus.values.map((OrderStatus status) {
                            return DropdownMenuItem<OrderStatus>(
                              value: status,
                              child: Text(
                                status.toString().split('.').last.capitalize!,
                                style: TextStyle(color: statusColor),
                              ),
                            );
                          }).toList(),
                          underline: SizedBox(), // Remove default underline
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total'),
                    Text(
                      '\$${order.totalAmount}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}