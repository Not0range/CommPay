import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/loading_indicator.dart';
import 'package:com_pay/widgets/overlay_widget.dart';
import 'package:com_pay/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:com_pay/api.dart' as api;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'main_route.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<StatefulWidget> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  bool remember = false;
  String phone = '';
  String password = '';

  bool loading = false;
  bool passwordError = false;

  void _setRemember(bool? value) {
    if (value == null) return;

    setState(() {
      remember = value;
    });
  }

  void _setPhone(String value) {
    setState(() {
      phone = value;
    });
  }

  void _setPassword(String value) {
    setState(() {
      password = value;
      passwordError = password.length < 5;
    });
  }

  void _setErrorText(bool value) {
    setState(() {
      passwordError = value;
    });
  }

  Future _login() async {
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration.zero, () async {
      if (phone.isEmptyOrSpace ||
          password.isEmptyOrSpace ||
          password.length < 5) {
        await showErrorDialog(
            context,
            AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.fieldsMustFilled,
            {AppLocalizations.of(context)!.ok: DialogResult.ok});
        return;
      }
      setState(() {
        loading = true;
      });

      try {
        String key = await api.login(phone, password);
        _goToMain(key);
      } on ClientException catch (_) {
        setState(() {
          loading = false;
        });
        showErrorDialog(context, AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.networkError, {
          AppLocalizations.of(context)!.refresh: DialogResult.retry,
          AppLocalizations.of(context)!.cancel: DialogResult.cancel
        }).then((value) {
          if (value == DialogResult.retry) _login();
        });
      }
    });
  }

  void _goToMain(String key) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => MainRoute(key)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.authorization),
        ),
        body: OverlayWidget(
          overlay: loading
              ? Container(
                  color: Colors.black.withAlpha(150),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: const LoadingIndicator(),
                )
              : Container(),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: SingleChildScrollView(
                child: Column(children: [
                  const Image(
                    image: AssetImage('assets/main_icon.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      AppLocalizations.of(context)!.comPay,
                      textScaleFactor: 1.7,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(AppLocalizations.of(context)!.authorization,
                        textScaleFactor: 1.7),
                  ),
                  TextInput(
                      text: phone,
                      placeholder: AppLocalizations.of(context)!.phone,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onChanged: _setPhone),
                  TextInput(
                      text: password,
                      placeholder: AppLocalizations.of(context)!.password,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      onFocus: () => _setErrorText(false),
                      onChanged: _setPassword,
                      obscureText: true,
                      subText: passwordError
                          ? AppLocalizations.of(context)!.passwordLength
                          : '',
                      subTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                  Row(
                    children: [
                      Checkbox(value: remember, onChanged: _setRemember),
                      GestureDetector(
                          onTap: () => _setRemember(!remember),
                          child: Text(AppLocalizations.of(context)!.remember))
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: _login,
                    icon: const Icon(Icons.login),
                    label: Text(AppLocalizations.of(context)!.login),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
