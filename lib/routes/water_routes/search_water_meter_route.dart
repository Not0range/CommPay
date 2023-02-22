import 'package:com_pay/api.dart' as api;
import 'package:com_pay/routes/water_routes/water_meter_route.dart';
import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/retry_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../entities/water/water_meter.dart';
import '../../widgets/water_meter_item.dart';

class SearchWaterMeterRoute extends StatefulWidget {
  final String keyString;

  const SearchWaterMeterRoute({super.key, required this.keyString});

  @override
  State<StatefulWidget> createState() => _SearchWaterMeterRouteState();
}

class _SearchWaterMeterRouteState extends State<SearchWaterMeterRoute> {
  FocusNode focus = FocusNode();

  bool first = true;
  bool loading = false;
  bool error = false;
  String text = '';
  List<WaterMeter> meters = [];

  @override
  void initState() {
    super.initState();
    focus.requestFocus();
  }

  void _onChanged(String value) {
    setState(() {
      text = value;
      error = false;
    });
  }

  Future _search() async {
    if (text.isEmptyOrSpace) return;
    setState(() {
      first = false;
      loading = true;
      error = false;
    });
    try {
      var list = await api.searchWaterMeter(widget.keyString, text);
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
    }
  }

  void _goToMeasurment(BuildContext context, WaterMeter meter) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) =>
                WaterMeterRoute(keyString: widget.keyString, meter: meter)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(5)),
          child: TextField(
            onChanged: _onChanged,
            focusNode: focus,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.serialNumber),
          ),
        ),
        actions: [
          IconButton(onPressed: _search, icon: const Icon(Icons.search))
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: error
                  ? Center(child: RetryWidget(onPressed: _search))
                  : meters.isEmpty
                      ? Center(
                          child: Text(first
                              ? AppLocalizations.of(context)!.searchInvite
                              : AppLocalizations.of(context)!.noResults),
                        )
                      : ListView.builder(
                          itemCount: meters.length,
                          itemBuilder: (ctx, i) => WaterMeterItem(
                                title: meters[i].title,
                                prev: meters[i].prevMeasurment,
                                last: meters[i].lastMeasurment,
                                onTap: () =>
                                    _goToMeasurment(context, meters[i]),
                              )),
            ),
    );
  }
}
