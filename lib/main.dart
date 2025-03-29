import 'dart:ui';
import 'package:firstapp/pages/dashboard.dart';
import 'package:firstapp/pages/input.dart';
import 'package:firstapp/pages/transactions.dart';
import 'package:flutter/material.dart';//complex and simple elements

void main(){  
  runApp( MyApp() );//global function which takes a single widget as an argument and inflate it to screen
  
}
//stateless no dynamic data
//extends from inbuilt class statelesswidget

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { //build function returns Widget type whenever data changes inside
    return MaterialApp(
      home: DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Finance App'),
          toolbarHeight: kToolbarHeight,
          bottom: const TabBar(tabs: [
          Tab(text: 'Input'),
          Tab(text: 'Dashboard'),
          Tab(text: 'Transactions'),
        ]),
        ),
        body: TabBarView(children: [
          Padding(padding: EdgeInsets.all(0),
            child: Input()
          ),
          Padding(padding: EdgeInsets.all(0),
          child: DashBoard()
          ),
         Padding(padding: EdgeInsets.all(0),
          child: Transactions()
          ),
        ],)

      )
    )
    );
  }
}
