import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:byday/src/core/assets/assets.gen.dart'; // Updated for By Day branding.
import 'package:byday/src/core/extensions/extensions.dart'; // Updated import path.
import 'package:byday/src/core/routes/app_router.dart'; // Updated import path.
import 'package:byday/src/core/theme/app_styles.dart'; // Updated import path.
import 'package:byday/src/core/theme/theme.dart'; // Updated import path.
import 'package:byday/src/core/widgets/widgets.dart'; // Updated import path.

@RoutePage()
class LoginChoiceView extends StatelessWidget {
  const LoginChoiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Assets.images.logo.image(),
              const Spacer(),
              Text(
                'Have a Problem you cannot solve? Don\'t worry. Let\'s get started',
                textAlign: TextAlign.center,
                style: AppStyles.text18PxMedium.white,
              ),
              const Spacer(),
              CustomButton(
                title: 'Get Service',
                onPressed: () => context.router.push(const LoginUserRoute()),
                isDisabled: false,
                backgroundColor: AppColors.whiteColor,
                titleStyle: AppStyles.text14PxMedium.softBlack,
                width: 270,
              ),
              30.verticalSpace,
              CustomButton(
                title: 'Provide Service',
                onPressed: () =>
                    context.router.push(const MerchantLoginRoute()),
                isDisabled: false,
                backgroundColor: AppColors.whiteColor,
                titleStyle: AppStyles.text14PxMedium.softBlack,
                width: 270,
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
