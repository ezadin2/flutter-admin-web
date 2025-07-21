import 'package:ecommerce_admin_panel/common/styles/user_model.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key, required this.customer});
  final UserModel customer;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('customer information ',
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              TRoundedImage(
                padding: 0,
                backgroundColor: TColors.primaryBackground,
                image: customer.profilePicture.isNotEmpty
                    ? customer.profilePicture
                    : TImages.user,
                imageType: customer.profilePicture.isNotEmpty
                    ? ImageType.network
                    : ImageType.asset,
              ),
              SizedBox(width: TSizes.spaceBtwSections),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                    Text(customer.email,
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              SizedBox(width: 120, child: Text('username')),
              Text(';'),
              SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text(customer.username,
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              SizedBox(width: 120, child: Text('country')),
              Text(';'),
              SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text('wolkite',
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              SizedBox(width: 120, child: Text('phone number')),
              Text(';'),
              SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text(customer.phoneNumber,
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          Divider(),
          SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('last order',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text('7 days ago ,#[356]'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Average order',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text('\$354'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('register', style: Theme.of(context).textTheme.titleLarge),
                    Text(customer.formattedDate),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.email, style: Theme.of(context).textTheme.titleLarge),
                    Text('7 days ago ,#[356]'),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
