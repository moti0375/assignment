import 'package:flutter/material.dart';
import 'package:moti_assignment/data/app_repository.dart';
import 'package:moti_assignment/network/http_client.dart';
import 'package:moti_assignment/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AppRepository>(
      create: (context) => AppRepositoryImpl(HttpClient()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

