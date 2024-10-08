import 'package:flutter/material.dart';
import 'dart:io';
import 'package:todo_app_test/pages/list_page.dart';



class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main(){
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: ListPage.ROUTE,
      routes: {
        ListPage.ROUTE:(_) => const ListPage(),
      },
  );
  }
}
