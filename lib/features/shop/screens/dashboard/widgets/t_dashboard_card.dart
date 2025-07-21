import 'package:ecommerce_admin_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TDashboardCard extends StatelessWidget {
  const TDashboardCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.stats,
    required this.previousPeriod,
    required this.isPositive,
    this.onTap,
    required this.headingIcon,
    required this.headingIconColor,
    required this.headingIconBgColor,
  });

  final IconData headingIcon;
  final String title, subTitle, previousPeriod;
  final int stats;
  final bool isPositive;
  final void Function()? onTap;
  final Color headingIconColor, headingIconBgColor;

  @override
  Widget build(BuildContext context) {
    // Determine icon and color based on whether stats are positive
    final IconData icon = isPositive ? Iconsax.arrow_up_3 : Iconsax.arrow_down;
    final Color color = isPositive ? TColors.success : TColors.error;
    final Color textColor = isPositive ? TColors.success : TColors.error;

    return TRoundedContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(TSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon at the top
          TCircularIcon(
            icon: headingIcon,
            backgroundColor: headingIconBgColor,
            color: headingIconColor,
            size: TSizes.md,
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          // Title
          TSectionHeading(
            title: title,
            textColor: TColors.textSecondary,
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Bottom row with value and stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Main value
              Flexible(
                child: Text(
                  subTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Stats column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Percentage row
                  // In the percentage row of TDashboardCard
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: color, size: TSizes.iconSm),
                      const SizedBox(width: 4),
                      Text(
                        '${stats.abs()}%',
                        style: Theme.of(context).textTheme.titleLarge!.apply(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),

                  // Comparison text
                  Text(
                    'vs $previousPeriod',
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}