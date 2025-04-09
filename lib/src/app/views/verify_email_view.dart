import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:byday/src/core/extensions/context_extension.dart';
import 'package:byday/src/core/extensions/extensions.dart';
import 'package:byday/src/core/providers/firebase_provider.dart';
import 'package:byday/src/core/theme/app_styles.dart';
import 'package:byday/src/core/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isVerified,
      child: ScaffoldWrapper(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Verify Your Email', style: AppStyles.text26PxBold),
              10.verticalSpace,
              Text.rich(
                TextSpan(
                  style: AppStyles.text14PxLight,
                  children: [
                    const TextSpan(text: 'We\'ve sent an email to '),
                    TextSpan(
                      text: widget.email,
                      style: AppStyles.text14PxMedium.primary,
                    ),
                    const TextSpan(text: ' Please verify your email and continue.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              Consumer(
                builder: (context, ref, child) {
                  return CustomButton(
                    title: 'Continue',
                    isDisabled: false,
                    onPressed: () async {
                      final authProvider = ref.read(firebaseAuthProvider);
                      await authProvider.currentUser?.reload();
                      final currentUser = authProvider.currentUser;
                      isVerified = currentUser?.emailVerified ?? false;
                      if (currentUser?.emailVerified == false) {
                        context.showSnackbar(message: 'Email not verified yet');
                      } else {
                        context.router.maybePop();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
