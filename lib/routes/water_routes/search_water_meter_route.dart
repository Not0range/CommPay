import 'package:com_pay/api.dart' as api;
import 'package:com_pay/routes/water_routes/water_meter_route.dart';
import 'package:com_pay/utils.dart';
import 'package:flutter/material.dart';

import '../../entities/water_meter.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/water_meter_item.dart';

class SearchWaterMeterRoute extends StatefulWidget {
  final String keyString;

  const SearchWaterMeterRoute({super.key, required this.keyString});

  @override
  State<StatefulWidget> createState() => _SearchWaterMeterRouteState();
}

class _SearchWaterMeterRouteState extends State<SearchWaterMeterRoute> {
  FocusNode focus = FocusNode();

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
    });
  }

  Future _search() async {
    if (text.isEmptyOrSpace) return;
    setState(() {
      loading = true;
    });
    var list = await api.searchWaterMeter(widget.keyString, text);
    if (mounted) {
      list.sort((a, b) => a.title.compareTo(b.title));
      setState(() {
        meters = list;
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
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: TextField(
            onChanged: _onChanged,
            focusNode: focus,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
          ),
        ),
        actions: [
          IconButton(onPressed: _search, icon: const Icon(Icons.search))
        ],
      ),
      body: loading
          ? const Center(
              child: LoadingIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView.builder(
                  itemCount: meters.length,
                  itemBuilder: (ctx, i) => WaterMeterItem(
                        title: meters[i].title,
                        prev: meters[i].prevMeasurment,
                        last: meters[i].lastMeasurment,
                        backgroundColor:
                            i % 2 == 0 ? Colors.green[200]! : Colors.blue[200]!,
                        onTap: () => _goToMeasurment(context, meters[i]),
                      )),
            ),
    );
  }
}
