import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/auth/login_provider.dart';
import '../providers/auth/otp_state_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../sheetes/otp_verify_sheet.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginProvider);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBarClipper(
                  title: trans().login,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Form(
                      key: loginKey,
                      autovalidateMode: autoValidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Image.asset(mybooking, height: 50),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              trans().login_subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            readOnly: login.isLoading(),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              prefixIconColor: CustomTheme.color2,
                              prefixText: '+967 ',
                              prefixStyle: const TextStyle(
                                color: CustomTheme.color3,
                                fontWeight: FontWeight.w400,
                              ),
                              labelText: trans().phone_number,
                              labelStyle: const TextStyle(
                                color: CustomTheme.color3,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: CustomTheme.primaryColor.withValues(alpha: 0.1 * 255),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: CustomTheme.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return trans().phoneFieldIsRequired;
                              } else if (value.length != 9) {
                                return "رقم الهاتف يجب أن يتكون من 9 أرقام";
                              } else if (!value.startsWith('7') && !value.startsWith('٧')) {
                                return "رقم الهاتف يجب أن يبدأ بـ 7";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final normalized = convertToEnglishNumbers(value);
                              ref.read(phoneProvider.notifier).state = normalized;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 16,
            ),
            child: Hero(
              tag: 'login',
              child: Button(
                width: double.infinity,
                title: trans().login,
                disable: login.isLoading(),
                icon: const Icon(Icons.login, color: Colors.white),
                iconAfterText: true,
                onPressed: () async {
                  final phone = ref.read(phoneProvider);
                  if (phone.length != 9 || !phone.startsWith('7')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "الرجاء إدخال رقم هاتف صحيح مكون من 9 أرقام ويبدأ بـ 7"),
                      ),
                    );
                    return;
                  }

                  if (loginKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    loginKey.currentState!.save();

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const OtpVerifySheet(),
                    );

                    await ref.read(loginProvider.notifier).requestOtp();
                  }

                  setState(() => autoValidate = true);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
