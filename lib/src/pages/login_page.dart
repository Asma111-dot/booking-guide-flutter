import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/login_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/primary_button_widget.dart';

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

    return Scaffold(
      appBar: AppBar(
        leading: !Navigator.canPop(context) ? null : const BackButtonWidget(),
        title: Text(trans().login),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + 64),
          padding: EdgeInsets.fromLTRB(16,16,16,16+MediaQuery.of(context).padding.bottom),
          child: Form(
            key: loginKey,
            autovalidateMode: autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 32),
                  child: Image.asset(logoCoverImage, height: 40),
                ),

                const SizedBox(height: 16,),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    initialValue: kDebugMode ? 'asma@booking.com' : null,
                    readOnly: login.isLoading(),
                    decoration: InputDecoration(
                      labelText: trans().email,
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
                    labelText: trans().password,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => hidePassword = !hidePassword);
                      },
                      icon: Icon(hidePassword ? visibleIcon : invisibleIcon),
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

                const SizedBox(height: 32,),

                Hero(
                  tag: 'login',
                  child: PrimaryButtonWidget(
                    text: trans().login,
                    loading: login.isLoading(),
                    onPressed: () async {
                      if(loginKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        loginKey.currentState!.save();
                        if(!hidePassword) {
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

                const SizedBox(height: 8,),

                const Expanded(child: SizedBox.shrink()),

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
                          const SizedBox(width: 8,),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Icon(externalLinkIcon, size: 16),
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
      ),
    );
  }
}