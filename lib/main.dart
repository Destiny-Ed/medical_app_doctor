import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sensor_doctor_app/Provider/get_reading.dart';
import 'Screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// We're using HiveStore for persistence,
  // so we need to initialize Hive.
  await initHiveForFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: SensorSchema().getClient(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
