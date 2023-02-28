import 'package:com_pay/entities/water/water_meter.dart';
import 'package:com_pay/routes/water_routes/water_meter_route.dart';
import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/water_meter_item.dart';
import 'package:flutter/material.dart';
import 'package:com_pay/api.dart' as api;
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

class MyWaterMetersRoute extends StatefulWidget {
  final String keyString;
  const MyWaterMetersRoute({super.key, required this.keyString});

  @override
  State<StatefulWidget> createState() => _MyWaterMetersRouteState();
}

class _MyWaterMetersRouteState extends State<MyWaterMetersRoute> {
  FocusNode focus = FocusNode();
  TextEditingController controller = TextEditingController();

  List<WaterMeter> meters = [];
  bool loading = false;
  bool error = false;
  bool search = false;
  String searchText = '';
  bool desc = false;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future _loadData() async {
    setState(() {
      error = false;
      loading = true;
    });
    try {
      var list = await api.getWaterMeters(widget.keyString);
      if (mounted) {
        list.sort((a, b) => a.title.compareTo(b.title));
        setState(() {
          meters = list;
          loading = false;
        });
      }
    } on ClientException catch (_) {
      setState(() {
        error = true;
        loading = false;
      });
      showErrorDialog(context, AppLocalizations.of(context)!.error,
          AppLocalizations.of(context)!.networkError, {
        AppLocalizations.of(context)!.refresh: DialogResult.retry,
        AppLocalizations.of(context)!.cancel: DialogResult.cancel
      }).then((value) {
        if (value == DialogResult.retry) {
          _loadData();
        } else {
          Navigator.pop(context);
        }
      });
    }
  }

  void _search() {
    setState(() {
      search = true;
    });
    focus.requestFocus();
  }

  void _cancelSearch() {
    controller.clear();
    setState(() {
      search = false;
      searchText = '';
    });
  }

  void _setSearchText(String value) {
    setState(() {
      searchText = value;
    });
  }

  void _clearSearch() {
    controller.clear();
    _setSearchText('');
  }

  void _setDesc(bool value) {
    setState(() {
      desc = value;
      if (desc) {
        meters.sort((a, b) => b.title.compareTo(a.title));
      } else {
        meters.sort((a, b) => a.title.compareTo(b.title));
      }
    });
  }

  Future _goToMeasurment(BuildContext context, WaterMeter meter) async {
    bool? result = await Navigator.push(
        context,
        MaterialPageRoute<bool>(
            builder: (ctx) =>
                WaterMeterRoute(keyString: widget.keyString, meter: meter)));
    if (result == null || result) await _loadData();
  }

  Future<bool> _willPop() async {
    if (search) {
      _cancelSearch();
      return false;
    }
    return true;
  }

  AppBar _getAppBar() {
    return loading
        ? loadingAppBar(context)
        : error
            ? errorAppBar(context)
            : search
                ? AppBar(
                    leading: IconButton(
                        onPressed: _cancelSearch,
                        icon: const Icon(Icons.arrow_back)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        focusNode: focus,
                        controller: controller,
                        onChanged: _setSearchText,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.search),
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.close))
                    ],
                  )
                : AppBar(
                    title:
                        Text('${AppLocalizations.of(context)!.myWaterMeters}: '
                            '${meters.length}'),
                    actions: [
                      IconButton(
                          onPressed: _search, icon: const Icon(Icons.search)),
                      AnimatedContainer(
                          transform: Matrix4.rotationX(desc ? math.pi : 0),
                          duration: const Duration(milliseconds: 200),
                          transformAlignment: Alignment.center,
                          child: IconButton(
                              onPressed: () => _setDesc(!desc),
                              icon: const Icon(Icons.sort))),
                    ],
                  );
  }

  @override
  Widget build(BuildContext context) {
    List<WaterMeter> list = meters;
    if (search && !searchText.isEmptyOrSpace) {
      list = meters
          .where((el) => el.title
              .contains(RegExp(searchText.trim(), caseSensitive: false)))
          .toList();
    }
    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        appBar: _getAppBar(),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : error
                ? Container()
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: list.isNotEmpty
                        ? ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (ctx, i) => WaterMeterItem(
                                  backgroundColor: i % 2 == 0
                                      ? Theme.of(context).canvasColor
                                      : Theme.of(context).dividerColor,
                                  title: list[i].title,
                                  favorite: list[i].isFavorite,
                                  prev: list[i].prevMeasurment,
                                  last: list[i].lastMeasurment,
                                  onTap: () =>
                                      _goToMeasurment(context, list[i]),
                                ))
                        : Center(
                            child:
                                Text(AppLocalizations.of(context)!.noResults),
                          ),
                  ),
      ),
    );
  }
}
