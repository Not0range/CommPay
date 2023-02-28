import 'dart:convert';
import 'dart:io';

import 'package:com_pay/entities/photo_send.dart';
import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/overlay_widget.dart';
import 'package:com_pay/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:com_pay/api.dart' as api;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_model.dart';
import 'main_route.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<StatefulWidget> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController passwordController = TextEditingController();

  bool remember = false;
  String? phone;
  String password = '';

  bool login = false;
  bool loading = true;
  bool passwordError = false;
  bool passwordVisible = false;

  String version = '';

  @override
  void initState() {
    super.initState();
    _loadStorage();
  }

  Future _loadStorage() async {
    var info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('photo_queue')) {
        var list = prefs.getStringList('photo_queue');
        if (list != null) {
          var psList = list.map((e) => PhotoSend.fromJson(jsonDecode(e)));
          for (var e in psList) {
            e.paths.removeWhere((el) => !File(el).existsSync());
          }
          Provider.of<AppModel>(context, listen: false)
              .addAll(psList.where((e) => e.paths.isNotEmpty));
        }
      }

      if (prefs.containsKey('phone') && prefs.containsKey('password')) {
        var phone = prefs.getString('phone');
        var password = prefs.getString('password');
        if (phone != null && password != null) {
          passwordController.text = password;
          setState(() {
            this.phone = phone;
            this.password = password;
            remember = true;
          });
        }
      }
      _setLoading(false);
    });
  }

  void _setLogin(bool value) {
    setState(() {
      login = value;
    });
  }

  void _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  void _setRemember(bool? value) {
    if (value == null) return;

    setState(() {
      remember = value;
    });
  }

  void _setPhone(String? value) {
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

  void _setPasswordVisible(bool value) {
    setState(() {
      passwordVisible = value;
    });
  }

  void _clearPassword() {
    _setPassword('');
    passwordController.clear();
  }

  Future _login() async {
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration.zero, () async {
      if (phone == null ||
          phone!.isEmptyOrSpace ||
          password.isEmptyOrSpace ||
          password.length < 5) {
        await showErrorDialog(
            context,
            AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.fieldsMustFilled,
            {AppLocalizations.of(context)!.ok: DialogResult.ok});
        return;
      }
      _setLogin(true);

      try {
        await api.login(phone!, password).then((key) async {
          if (key == null) {
            await showErrorDialog(
                context,
                AppLocalizations.of(context)!.error,
                AppLocalizations.of(context)!.loginError,
                {AppLocalizations.of(context)!.ok: DialogResult.ok});
            _setLogin(false);
            return;
          }
          var prefs = await SharedPreferences.getInstance();
          if (remember) {
            prefs.setString('phone', phone!);
            prefs.setString('password', password);
          } else {
            prefs.remove('phone');
            prefs.remove('password');
          }

          _goToMain(key);
        });
      } on ClientException catch (_) {
        _setLogin(false);
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
          overlay: login
              ? Container(
                  color: Colors.black.withAlpha(150),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: const CircularProgressIndicator(),
                )
              : Container(),
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 40),
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
                          child: Text(
                              AppLocalizations.of(context)!.authorization,
                              textScaleFactor: 1.7),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Theme.of(context).disabledColor)),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              DropdownButton<String>(
                                  underline: Container(),
                                  isExpanded: true,
                                  value: phone,
                                  items: api.phoneNumbers.keys
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList()
                                    ..insert(
                                        0,
                                        const DropdownMenuItem(
                                          value: null,
                                          child: Text(' - '),
                                        )),
                                  onChanged: _setPhone),
                              Positioned(
                                  top: -13,
                                  left: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: Text(
                                      AppLocalizations.of(context)!.phone,
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        TextInput(
                          text: password,
                          controller: passwordController,
                          placeholder: AppLocalizations.of(context)!.password,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          onFocus: () => _setErrorText(false),
                          onChanged: _setPassword,
                          onSubmit: (_) => _setErrorText(password.length < 5),
                          obscureText: !passwordVisible,
                          subText: passwordError
                              ? AppLocalizations.of(context)!.passwordLength
                              : '',
                          subTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                          iconButton: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      _setPasswordVisible(!passwordVisible),
                                  icon: Icon(passwordVisible
                                      ? Icons.remove_red_eye
                                      : Icons.remove_red_eye_outlined)),
                              IconButton(
                                  onPressed: _clearPassword,
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(value: remember, onChanged: _setRemember),
                            GestureDetector(
                                onTap: () => _setRemember(!remember),
                                child: Text(
                                    AppLocalizations.of(context)!.remember))
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.login),
                          label: Text(AppLocalizations.of(context)!.login),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                              '${AppLocalizations.of(context)!.version}: $version'),
                        )
                      ]),
                    ),
                  ),
                ),
        ));
  }
}
