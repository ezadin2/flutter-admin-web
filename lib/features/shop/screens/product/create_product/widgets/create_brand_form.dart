import 'package:ecommerce_admin_panel/common/widgets/chips/rounded_choice_chips.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CreateBrandForm extends StatelessWidget {
  const CreateBrandForm({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: TSizes.sm),
          Text(
            'Create New Brand',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Brand Name', prefixIcon: Icon(Iconsax.box)),
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          Text(
            'Select Categories',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: TSizes.spaceBtwInputFields / 2),
          Wrap(
            spacing: TSizes.sm,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: TSizes.sm),
                child: TChoiceChip(
                  text: 'Shoes',
                  selected: true,
                  onSelected: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: TSizes.sm),
                child: TChoiceChip(
                  text: 'Track Suits',
                  selected: false,
                  onSelected: (value) {},
                ),
              ),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwInputFields *2,),

          TImageUploader(imageType: ImageType.asset,
          width: 80,
            height: 80,
            image: TImages.defaultImage,
            onIconButtonPressed: (){},
          ),
          SizedBox(height: TSizes.spaceBtwInputFields,),
          CheckboxMenuButton(value: true, onChanged: (value){}, child: Text('Featured')),
          SizedBox(height: TSizes.spaceBtwInputFields *2,),
          SizedBox(width: double.infinity,
          child: ElevatedButton(onPressed: (){}, child: Text('Create')),


          ),
          SizedBox(height: TSizes.spaceBtwInputFields *2,),
        ],
      )),
    );
  }
}
