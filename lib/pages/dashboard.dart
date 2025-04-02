import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/database.dart' as db;
import 'package:sqflite/sqflite.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    final db.DatabaseService _transactions = db.DatabaseService.instance;
    List<db.Transaction>? _list;
    List<int>? last5;
    List<int>? _amount;
     Future<void> fetchTransactions() async {
      List<db.Transaction> temp = await _transactions.getTransactions();
      setState(() {
        _list = temp;
        _amount = _list!.map((_list)=>_list.amount).toList();
        last5 = _amount!.sublist(_amount!.length - 5);
      });
  }
   return Column(
    children: [
      Container(
      alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 15, top: 25),
                child: const Text('Dashboard',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                ),         
      ),
      LineChart(
        LineChartData(lineBarsData: _amount)
      )

    ]
    );
            
  }
}
