import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:byday/src/auth/providers/forms/login/user_login_form_provider.dart'; // Updated import for By Day branding.
import 'package:byday/src/auth/providers/user_login_provider.dart'; // Updated import for By Day branding.
import 'package:byday/src/core/extensions/context_extension.dart'; // Updated import path.
import 'package:byday/src/core/extensions/extensions.dart'; // Updated import path.
import 'package:byday/src/core/routes/app_router.dart'; // Updated import path.
import 'package:byday/src/core/state/app_state.dart'; // Updated import path.
import 'package:byday/src/core/theme/app_styles.dart'; // Updated import path.
import 'package:byday/src/core/widgets/widgets.dart'; // Updated import path.
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class LoginUserView extends HookConsumerWidget {
  const LoginUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _email = useTextEditingController();
    final _password = useTextEditingController();

    // Listen for login state changes
    ref.listen(userLoginProvider, (previous, next) {
      final state = next as AppState;
      state.maybeWhen(
        orElse: () => null,
        error: (message) => context.showSnackbar(message: message),
        success: (data) => context.router.push(
          WelcomeRoute(
            buttonTitle: 'Back To Home',
            onPressed: () {
              context.router.replaceAll([const DashboardRouter()]);
            },
          ),
        ),
      );
    });

    return ScaffoldWrapper(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, ref, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                Text(
                  'Here To Get \nWelcome!',
                  style: AppStyles.text24PxBold,
                ),
                80.verticalSpace,
                Consumer(
                  builder: (context, ref, child) {
                    return CustomTextField(
                      onChanged: (email) => ref
                          .read(userLoginFormProvider.notifier)
                          .setEmail(email),
                      title: 'Email',
                      textInputType: TextInputType.emailAddress,
                      error: ref
                          .watch(userLoginFormProvider)
                          .form
                          .email
                          .errorMessage,
                      controller: _email,
                    );
                  },
                ),
                30.verticalSpace,
                CustomTextField(
                  title: 'Password',
                  onChanged: (password) => ref
                      .read(userLoginFormProvider.notifier)
                      .setPassword(password),
                  isPassword: true,
                  error: ref
                      .watch(userLoginFormProvider)
                      .form
                      .password
                      .errorMessage,
                  controller: _password,
                  textInputType: TextInputType.visiblePassword,
                ),
                30.verticalSpace,
                Align(
                  child: CustomButton(
                    isDisabled: !ref.watch(userLoginFormProvider).form.isValid,
                    onPressed: () =>
                        ref.read(userLoginProvider.notifier).loginAsUser(
                              email: _email.text,
                              password: _password.text,
                            ),
                    title: 'Sign in',
                    loading: ref.watch(userLoginProvider).maybeWhen(
                          orElse: () => false,
                          loading: () => true,
                        ),
                  ),
                ),
                40.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have account? ',
                      style: AppStyles.text14PxRegular.midGrey,
                    ),
                    TextButton(
                      onPressed: () =>
                          context.router.push(const UserSignupRoute()),
                      child: const Text('Signup'),
                    ),
                  ],
                ),
              ],
            ).px(20);
          },
        ),
      ),
    );
  }
}
