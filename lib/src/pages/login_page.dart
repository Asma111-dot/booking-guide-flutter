import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/login_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool hidePassword = true;

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
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  16 + MediaQuery.of(context).padding.bottom,
                ),
                child: Form(
                  key: loginKey,
                  autovalidateMode: autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 30),
                        child: Image.asset(logoCoverImage, height: 60),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          initialValue: kDebugMode ? 'asma@booking.com' : null,
                          readOnly: login.isLoading(),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            prefixIconColor: CustomTheme.tertiaryColor,
                            labelText: trans().email,
                            labelStyle: const TextStyle(
                              color: CustomTheme.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color:
                                    CustomTheme.primaryColor.withOpacity(0.7),
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
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator().call,
                          onSaved: (value) => login.data!.email = value!,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      TextFormField(
                        initialValue: kDebugMode ? 'asmaa123' : null,
                        readOnly: login.isLoading(),
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          prefixIconColor: CustomTheme.tertiaryColor,
                          labelText: trans().password,
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => hidePassword = !hidePassword);
                            },
                            icon: Icon(hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: passwordValidator.call,
                        onSaved: (value) => login.data!.password = value!,
                        textInputAction: TextInputAction.done,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(trans().doYouForgetYourPassword),
                            onPressed: () {
                              //
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 32),
                      Hero(
                        tag: 'login',
                        child: Button(
                          width: double.infinity,
                          title: trans().login,
                          disable: login.isLoading(),
                          onPressed: () async {
                            if (loginKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              loginKey.currentState!.save();
                              if (!hidePassword) {
                                setState(() {
                                  hidePassword = true;
                                });
                              }
                              await ref.read(loginProvider.notifier).submit();
                              return;
                            }
                            setState(() => autoValidate = true);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(trans().byProceedingYouAgreeToThe),
                          TextButton(
                            onPressed: () {
                              //
                            },
                            child: Row(
                              children: [
                                Text(trans().termsOfUse),
                                const SizedBox(width: 8),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 4.0),
                                  child: Icon(Icons.open_in_new, size: 16),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
