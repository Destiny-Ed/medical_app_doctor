import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sensor_doctor_app/Model/ecg_model.dart';
import 'package:sensor_doctor_app/Schema/get_reading_schema.dart';
import 'package:sensor_doctor_app/Screens/vital_signs_field.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<LiveData> chartDataX;
  late ChartSeriesController _chartSeriesControllerX;

  late List<LiveData> chartDataY;
  late ChartSeriesController _chartSeriesControllerY;

  late List<LiveData> chartDataZ;
  late ChartSeriesController _chartSeriesControllerZ;

  // late AccelerometerEvent _accelerometerValues;

  Timer? _timer;

  Widget? graphWidget;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://medikal-backend.herokuapp.com/ws/get-sensor-readings'));

  String activity = "";

  @override
  void initState() {
    super.initState();

    ///Populate chart with initial data
    chartDataX = getChartData();
    chartDataY = getChartData();
    chartDataZ = getChartData();
    // _timer = Timer.periodic(const Duration(seconds: 1), updateDataSource);

    // accelerometerEvents.listen(
    //   (AccelerometerEvent event) {
    //     setState(() {
    //       _accelerometerValues = event;
    //     });
    //   },
    // );

    channel.stream.listen((event) {
      final data = json.decode(event.toString());

      setState(() {
        activity = data[0]["activity"];
      });

      // Timer.periodic(
      //   const Duration(seconds: 2),
      //   (timer) {
          print(
              "dkfjdkfjdkfjdf ============================================================= ${data[0]["x"]}");
          updateDataSource(
              double.parse(data[0]["x"].toString()),
              double.parse(data[0]["y"].toString()),
              double.parse(data[0]["z"].toString()));
        },
      );
    // });
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Doctor app"),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height - 40,
                  child: Column(
                    // primary: true,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height: 220,
                              child: SfCartesianChart(
                                series: <SplineSeries<LiveData, int>>[
                                  SplineSeries<LiveData, int>(
                                    onRendererCreated:
                                        (ChartSeriesController controller) {
                                      _chartSeriesControllerX = controller;
                                    },
                                    dataSource: chartDataX,
                                    color: Colors.green,
                                    xValueMapper: (LiveData sales, _) =>
                                        sales.time,
                                    yValueMapper: (LiveData sales, _) =>
                                        sales.speed,
                                  ),
                                  SplineSeries<LiveData, int>(
                                    onRendererCreated:
                                        (ChartSeriesController controller) {
                                      _chartSeriesControllerY = controller;
                                    },
                                    dataSource: chartDataY,
                                    color: Colors.red,
                                    xValueMapper: (LiveData sales, _) =>
                                        sales.time,
                                    yValueMapper: (LiveData sales, _) =>
                                        sales.speed,
                                  ),
                                  SplineSeries<LiveData, int>(
                                    onRendererCreated:
                                        (ChartSeriesController controller) {
                                      _chartSeriesControllerZ = controller;
                                    },
                                    dataSource: chartDataZ,
                                    color: Colors.blue,
                                    xValueMapper: (LiveData sales, _) =>
                                        sales.time,
                                    yValueMapper: (LiveData sales, _) =>
                                        sales.speed,
                                  )
                                ],
                                primaryXAxis: NumericAxis(
                                    majorGridLines:
                                        const MajorGridLines(width: 0),
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift,
                                    interval: 3,
                                    title:
                                        AxisTitle(text: 'TimeStamp (seconds)')),
                                primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(width: 0),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                    title: AxisTitle(text: 'Dimenison (m/s^2')),
                              ),
                            ),

                            ///User Activity
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              child: Text("User Activity : $activity",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue)),
                            ),
                          ],
                        ),
                      ),
                      // StreamBuilder(
                      //   stream: channel.stream,
                      //   builder: (context, snapshot){
                      //     if(snapshot.hasData){
                      //       // final data = json.decode(snapshot.data.toString());
                      //       //
                      //       // return Text(data[0]["x"].toString());
                      //       final data = json.decode(snapshot.data.toString());
                      //
                      //       ///Set Timer
                      // _timer = Timer.periodic(
                      //   const Duration(seconds: 5),
                      //       (Timer timer) {
                      //     print(data[0]["x"]);
                      //     updateDataSource(
                      //         double.parse(data[0]["x"].toString()),
                      //         double.parse(data[0]["y"].toString()),
                      //         double.parse(data[0]["z"].toString()));
                      //   },
                      // );
                      //       // updateDataSource(data["x"], data["y"], data["z"]);
                      //
                      // return Column(
                      //   children: [
                      //     Container(
                      //       height: 220,
                      //       child: SfCartesianChart(
                      //         series: <SplineSeries<LiveData, int>>[
                      //           SplineSeries<LiveData, int>(
                      //             onRendererCreated:
                      //                 (ChartSeriesController
                      //             controller) {
                      //               _chartSeriesControllerX =
                      //                   controller;
                      //             },
                      //             dataSource: chartDataX,
                      //             color: Colors.green,
                      //             xValueMapper: (LiveData sales, _) =>
                      //             sales.time,
                      //             yValueMapper: (LiveData sales, _) =>
                      //             sales.speed,
                      //           ),
                      //           SplineSeries<LiveData, int>(
                      //             onRendererCreated:
                      //                 (ChartSeriesController
                      //             controller) {
                      //               _chartSeriesControllerY =
                      //                   controller;
                      //             },
                      //             dataSource: chartDataY,
                      //             color: Colors.red,
                      //             xValueMapper: (LiveData sales, _) =>
                      //             sales.time,
                      //             yValueMapper: (LiveData sales, _) =>
                      //             sales.speed,
                      //           ),
                      //           SplineSeries<LiveData, int>(
                      //             onRendererCreated:
                      //                 (ChartSeriesController
                      //             controller) {
                      //               _chartSeriesControllerZ =
                      //                   controller;
                      //             },
                      //             dataSource: chartDataZ,
                      //             color: Colors.blue,
                      //             xValueMapper: (LiveData sales, _) =>
                      //             sales.time,
                      //             yValueMapper: (LiveData sales, _) =>
                      //             sales.speed,
                      //           )
                      //         ],
                      //         primaryXAxis: NumericAxis(
                      //             majorGridLines:
                      //             const MajorGridLines(width: 0),
                      //             edgeLabelPlacement:
                      //             EdgeLabelPlacement.shift,
                      //             interval: 3,
                      //             title: AxisTitle(
                      //                 text: 'TimeStamp (seconds)')),
                      //         primaryYAxis: NumericAxis(
                      //             axisLine: const AxisLine(width: 0),
                      //             majorTickLines:
                      //             const MajorTickLines(size: 0),
                      //             title: AxisTitle(
                      //                 text: 'Dimenison (m/s^2')),
                      //       ),
                      //     ),

                      //     ///User Activity
                      //     Container(
                      //       margin: const EdgeInsets.symmetric(
                      //           vertical: 10),
                      //       alignment: Alignment.center,
                      //       child: Text("User Activity : ${data[0]["activity"]}",
                      //           style: TextStyle(
                      //               fontSize: 18, color: Colors.blue)),
                      //     ),
                      //   ],
                      // );
                      //     }else{
                      //       return Text("Is Loading");
                      //     }
                      //   },
                      // ),
                      ///Graph View (ECG)
                      Expanded(
                        child:

                            ///Vital signs view
                            Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Vital Signs",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.red),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  vitalSigns(context,
                                      title: "Temperature(°C)", value: "37.0"),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  vitalSigns(context,
                                      title: "Heart Rate(bpm)", value: "60"),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  vitalSigns(context,
                                      title: "Blood Pressure(mmHg)",
                                      value: "107/61"),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  vitalSigns(context,
                                      title: "SPO2(%)", value: "95"),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  vitalSigns(context,
                                      title: "Respiration(breath/min)",
                                      value: "12"),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  int time = 19;
  void updateDataSource(double? x, double? y, double? z) {
    // chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
    ///!For X axis
    chartDataX.add(LiveData(time++, x!));
    chartDataX.removeAt(0);
    _chartSeriesControllerX.updateDataSource(
        addedDataIndex: chartDataX.length - 1, removedDataIndex: 0);

    ///!For Y axis
    chartDataY.add(LiveData(time++, y!));
    chartDataY.removeAt(0);
    _chartSeriesControllerY.updateDataSource(
        addedDataIndex: chartDataY.length - 1, removedDataIndex: 0);

    ///!For Y axis
    chartDataZ.add(LiveData(time++, z!));
    chartDataZ.removeAt(0);
    _chartSeriesControllerZ.updateDataSource(
        addedDataIndex: chartDataZ.length - 1, removedDataIndex: 0);
  }
}
