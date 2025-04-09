import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:byday/src/core/assets/assets.gen.dart'; // Updated for By Day branding.
import 'package:byday/src/core/extensions/extensions.dart'; // Updated import path.
import 'package:byday/src/core/theme/app_styles.dart'; // Updated import path.
import 'package:byday/src/core/widgets/widgets.dart'; // Updated import path.

@RoutePage()
class WelcomeView extends StatelessWidget {
  const WelcomeView(
      {Key? key, required this.onPressed, required this.buttonTitle})
      : super(key: key);

  final VoidCallback onPressed;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Assets.images.welcome.image(),
              20.verticalSpace,
              Text(
                'Welcome!',
                style: AppStyles.text30PxBold.softBlack,
              ),
              const Spacer(),
              Text(
                'Have a Problem \nyou cannot solve?\nDon\'t worry. Let\'s get started',
                textAlign: TextAlign.center,
                style: AppStyles.text18PxMedium.midGrey,
              ),
              const Spacer(),
              CustomButton(
                title: buttonTitle,
                isDisabled: false,
                width: 270.w,
                onPressed: () async {
                  onPressed();
                },
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
