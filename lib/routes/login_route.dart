import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:com_pay/api.dart' as api;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    });
  }

  Future _login() async {
    FocusScope.of(context).unfocus();
    if (phone.isEmptyOrSpace || password.isEmptyOrSpace) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.error),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(AppLocalizations.of(context)!.ok))
                ],
              ));
      return;
    }
    try {
      String key = await api.login(phone, password);
      _goToMain(key);
    } on Exception catch (_) {
      //TODO error handling
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.error),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(AppLocalizations.of(context)!.ok))
                ],
              ));
    }
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
      body: GestureDetector(
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
                  onSubmit: _setPhone),
              TextInput(
                  text: password,
                  placeholder: AppLocalizations.of(context)!.password,
                  textInputAction: TextInputAction.done,
                  onSubmit: _setPassword,
                  obscureText: true),
              Row(
                children: [
                  Checkbox(value: remember, onChanged: _setRemember),
                  GestureDetector(
                      onTap: () => _setRemember(!remember),
                      child: Text(AppLocalizations.of(context)!.remember))
                ],
              ),
              InkWell(
                onTap: _login,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.login),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(AppLocalizations.of(context)!.login),
                        ),
                      ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
