import 'package:com_pay/entities/water_meter.dart';
import 'package:com_pay/routes/water_routes/water_meter_route.dart';
import 'package:com_pay/utils.dart';
import 'package:com_pay/widgets/loading_indicator.dart';
import 'package:com_pay/widgets/water_meter_item.dart';
import 'package:flutter/material.dart';
import 'package:com_pay/api.dart' as api;
import 'dart:math' as math;

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
  bool loading = true;
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
    var list = await api.getWaterMeters(widget.keyString);
    if (mounted) {
      list.sort((a, b) => a.title.compareTo(b.title));
      setState(() {
        meters = list;
        loading = false;
      });
    }
  }

  void _serach() {
    setState(() {
      search = true;
    });
    focus.requestFocus();
  }

  void _cancelSerach() {
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
  }

  void _setDesc(bool value) {
    setState(() {
      if (desc) {
        meters.sort((a, b) => b.title.compareTo(a.title));
      } else {
        meters.sort((a, b) => a.title.compareTo(b.title));
      }
      desc = value;
    });
  }

  void _goToMeasurment(BuildContext context, WaterMeter meter) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) =>
                WaterMeterRoute(keyString: widget.keyString, meter: meter)));
  }

  AppBar _getAppBar() {
    return loading
        ? loadingAppBar(context)
        : error
            ? errorAppBar(context)
            : search
                ? AppBar(
                    leading: IconButton(
                        onPressed: _cancelSerach,
                        icon: const Icon(Icons.arrow_back)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        focusNode: focus,
                        controller: controller,
                        onChanged: _setSearchText,
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.close))
                    ],
                  )
                : AppBar(
                    actions: [
                      IconButton(
                          onPressed: _serach, icon: const Icon(Icons.search)),
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
    return Scaffold(
      appBar: _getAppBar(),
      body: loading
          ? const Center(
              child: LoadingIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (ctx, i) => WaterMeterItem(
                        title: list[i].title,
                        prev: list[i].prevMeasurment,
                        last: list[i].lastMeasurment,
                        backgroundColor:
                            i % 2 == 0 ? Colors.green[200]! : Colors.blue[200]!,
                        onTap: () => _goToMeasurment(context, list[i]),
                      )),
            ),
    );
  }
}
