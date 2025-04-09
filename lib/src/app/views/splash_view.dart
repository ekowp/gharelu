import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:byday/src/app/provider/auth_status_provider.dart';
import 'package:byday/src/auth/models/custom_user_model.dart';
import 'package:byday/src/core/assets/assets.gen.dart';
import 'package:byday/src/core/extensions/context_extension.dart';
import 'package:byday/src/core/extensions/extensions.dart';
import 'package:byday/src/core/providers/firebase_provider.dart';
import 'package:byday/src/core/routes/app_router.dart';
import 'package:byday/src/core/state/app_state.dart';
import 'package:byday/src/core/theme/app_colors.dart';
import 'package:byday/src/core/theme/app_styles.dart';
import 'package:byday/src/core/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SplashView extends HookConsumerWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AppState<CustomUserModel>>(authStatusNotifierProvider,
        (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        success: (data) {
          // Trigger any auth change listeners.
          ref.read(authChangeProvider);
          context.showSnackbar(message: 'Welcome Back ${data.name}');
          if (data.isMerchant) {
            // Navigate to the merchant dashboard.
            context.router.replaceAll([const MerchantDashboardRouter()]);
          } else {
            // Navigate to the user dashboard.
            context.router.replaceAll([const DashboardRouter()]);
          }
        },
        error: (message) async {
          context.showSnackbar(message: message);
          await Future.delayed(const Duration(milliseconds: 300));
          context.router.push(const LoginChoiceRoute());
        },
      );
    });

    return ScaffoldWrapper(
      backgroundColor: AppColors.primaryColor,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Assets.images.logo.image(),
            const Spacer(),
            Text(
              'Have a Problem \nyou cannot solve?\nDon\'t worry. Let\'s get started',
              textAlign: TextAlign.center,
              style: AppStyles.text18PxMedium.white,
            ),
            const Spacer(),
            Consumer(builder: (context, ref, _) {
              return ref.watch(authStatusNotifierProvider).maybeWhen(
                    orElse: () => buildButton(ref, context),
                    success: (data) => const SizedBox.shrink(),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.whiteColor,
                      ),
                    ),
                    error: (message) => buildButton(ref, context),
                  );
            }),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget buildButton(WidgetRef ref, BuildContext context) {
    return CustomButton(
      loading: ref.watch(authStatusNotifierProvider).maybeWhen(
            orElse: () => false,
            loading: () => true,
          ),
      title: 'Get Started',
      onPressed: () => context.router.push(const LoginChoiceRoute()),
      isDisabled: false,
      backgroundColor: AppColors.whiteColor,
      titleStyle: AppStyles.text14PxMedium.softBlack,
      width: 270,
    );
  }
}
