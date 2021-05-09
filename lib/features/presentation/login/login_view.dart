import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/core/extension/string_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:liv_social/core/navigation/routes.dart';
import 'package:liv_social/core/theme/pallete_color.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:liv_social/features/data/models/auth_type.dart';
import 'package:liv_social/features/presentation/login/login_cubit.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read(), context.read()),
      child: const LoginView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: PalleteColor.backgroundColor,
        child: Stack(
          children: [
            Positioned(
              bottom: -200,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/icons/login/background_login.svg',
                fit: BoxFit.fitWidth,
              ),
            ),
            const SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: _BodyLogin(),
                // resizeToAvoidBottomPadding: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyLogin extends HookWidget {
  const _BodyLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocus = useFocusNode();
    final bloc = context.watch<LoginCubit>();
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              Keys.login.localize(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: emailController,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: Keys.email.localize(),
                        labelStyle: const TextStyle(
                            fontSize: 16.0, color: Colors.black),
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffF0F0F0), width: 3.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffF0F0F0), width: 3.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                      ),
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.black),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                      onChanged: (value) => bloc.email = value,
                    ),
                    const SizedBox(height: 15.0),
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (previous, current) =>
                          current is LoginChangeObscureState,
                      builder: (context, state) {
                        var obscurePassword = bloc.obscurePassword;
                        if (state is LoginChangeObscureState) {
                          obscurePassword = state.obscureText;
                        }

                        return TextFormField(
                          controller: passwordController,
                          focusNode: passwordFocus,
                          obscureText: obscurePassword,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: Keys.password.localize(),
                            labelStyle: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffF0F0F0), width: 3.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffF0F0F0), width: 3.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () =>
                                  bloc.updateObscureText(!obscurePassword),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).unfocus(),
                          onChanged: (value) => bloc.password = value,
                        );
                      },
                    ),
                    const SizedBox(height: 15.0),
                    const SizedBox(height: 20.0),
                    FloatingActionButton(
                      heroTag: 'btnGoogle',
                      backgroundColor: Colors.transparent,
                      onPressed: () => bloc.login(AuthType.Google),
                      child: SvgPicture.asset(
                          'assets/icons/login/ic_google.svg',
                          fit: BoxFit.fitWidth),
                    ),
                    const SizedBox(height: 20.0),
                    const _ContinueButton(),
                    const SizedBox(height: 20.0),
                    const _EnrollAdvice(),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                        onPressed: () => bloc.logOut(), child: Text('Logout'))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<LoginCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => current is LoginUpdateFieldState,
      builder: (context, state) {
        return Container(
          height: 50,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .18),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              primary: PalleteColor.actionButtonColor,
            ),
            onPressed: !bloc.enableBtnContinue
                ? null
                : () => bloc.login(AuthType.Email),
            child: Text(Keys.continue_label.localize(),
                style: const TextStyle(fontSize: 16.0, color: Colors.white)),
          ),
        );
      },
    );
  }
}

class _EnrollAdvice extends StatelessWidget {
  const _EnrollAdvice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '${Keys.login_dont_have_account.localize()}.',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          children: <TextSpan>[
            TextSpan(
                text: Keys.sign_up.localize() + '\n\n',
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.of(context)
                      .pushNamed(Routes.login)), //TODO: update
          ],
        ),
      ),
    );
  }
}
