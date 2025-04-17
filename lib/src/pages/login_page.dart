import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/auth/login_provider.dart';
import '../providers/auth/otp_state_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/otp_verify_sheet.dart';

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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
            CustomAppBarClipper(
            backgroundColor: CustomTheme.primaryColor,
            height: 160.0,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 20.0),
                child: Text(
                  trans().login,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery
                  .of(context)
                  .padding
                  .bottom,
            ),
            child: Form(
              key: loginKey,
              autovalidateMode: autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                  children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Image.asset(logoCoverImage, height: 100),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  trans().login_subtitle,
                  style: TextStyle(
                    fontSize: 16,
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
                  prefixIconColor: CustomTheme.primaryColor,
                  prefixText: '+967 ',
                  prefixStyle: const TextStyle(
                    color: CustomTheme.tertiaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: trans().phone_number,
                  labelStyle: const TextStyle(
                    color: CustomTheme.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: CustomTheme.primaryColor.withOpacity(0.7),
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
                validator: (value) =>
                value == null || value.isEmpty
                    ? trans().phoneFieldIsRequired
                    : null,
                onChanged: (value) =>
                ref
                    .read(phoneProvider.notifier)
                    .state = value,
              ),
              const SizedBox(height: 32),
              // Hero(
              //   tag: 'login',
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: CustomTheme.primaryColor,
              //       minimumSize: const Size.fromHeight(50),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     icon: const Icon(Icons.login, color: Colors.white),
              //     label: Text(
              //       trans().login,
              //       style: const TextStyle(
              //         fontSize: 16,
              //         color: Colors.white,
              //       ),
              //     ),
              //     onPressed: login.isLoading()
              //         ? null
              //         : () async {
              //       if (loginKey.currentState!.validate()) {
              //         FocusManager.instance.primaryFocus?.unfocus();
              //         loginKey.currentState!.save();
              //         showModalBottomSheet(
              //           context: context,
              //           isScrollControlled: true,
              //           backgroundColor: Colors.transparent,
              //           builder: (_) => const OtpVerifySheet(),
              //         );
              //         await ref
              //             .read(loginProvider.notifier)
              //             .requestOtp();
              //       }
              //       setState(() => autoValidate = true);
              //     },
              //   ),
              // ),
              Hero(
                tag: 'login',
                child: Button(
                    width: double.infinity,
                    title: trans().login,
                    disable: login.isLoading(),
                    icon: const Icon(Icons.login, color: Colors.white),
                    iconAfterText: true,
                    onPressed: () async {
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
            ],
          ),
        ),
      ),
      ],
    ),)
    ,
    )
    ,
    );
  }
}
