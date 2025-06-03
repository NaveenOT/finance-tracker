import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/database.dart' as db;
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final db.DatabaseService _transactions = db.DatabaseService.instance;
    List<db.Transaction>? _list;
    List<int>? last5;
    List<int>? _amount;
    int? touchIndex;
  @override
  void initState(){
    super.initState();
    fetchTransactions();
  }
   Future<void> fetchTransactions() async {
      List<db.Transaction> temp = await _transactions.getTransactions();
      setState(() {
        _list = temp;
        _amount = _list!.map((_list)=>_list.amount).toList();
        last5 = _amount!.length >= 5 ? _amount!.sublist(_amount!.length - 5) : _amount;
        //use temp to section data    
      });
  }
  @override
  Widget build(BuildContext context) {
   return SingleChildScrollView(
    child: Column(
      children: <Widget>[
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
      const SizedBox(height: 20),
      last5!.length <= 0 ? const CircularProgressIndicator() :
      SizedBox(
        height: 300,
        width: 370,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: Offset(0, 4)
              )
            ],
          ),
          padding: EdgeInsets.all(30),
          child: LineChart(
        LineChartData(
         lineBarsData: [
          LineChartBarData(
            spots: List.generate(last5!.length, (index){
              return FlSpot(index.toDouble(), last5![index].toDouble());
            }),
            color: Colors.red,
            isCurved: true,
            curveSmoothness: 0.45,
            gradient: LinearGradient(colors: <Color>[Colors.lightGreenAccent, Colors.lightBlueAccent]),
            barWidth: 8,
            isStrokeCapRound: true,
            preventCurveOverShooting: true,
            dotData: FlDotData(show: true),
            
          )
         ],
      
         lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
  tooltipBorder: BorderSide(color: Colors.black12, width: 2),
  getTooltipColor: (touchedSpot)=> Colors.black,
  tooltipRoundedRadius: 15,
  getTooltipItems: (touchedSpots) {
    return touchedSpots.map((spot) {
      return LineTooltipItem(
        "Transaction ${spot.x.toInt() + 1}\n\$${spot.y.toInt()}",
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
      
    }).toList(); 
  },
)

         ),
         gridData: FlGridData(
          show: false,
         ),
         borderData: FlBorderData(
          show: false,
         ),
         titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, getTitlesWidget: (value, meta) {return Text("T${value.toInt() + 1}", style: TextStyle(color: Colors.grey, fontSize: 15));})),
         ),
        ),
      ) ,
        )
      ),
      SizedBox(height: 40),
      Padding(padding: EdgeInsets.all(30),
        child: Text('Expense Chart', style: TextStyle()),
      ),
      SizedBox(
        height: 300,
        width: 370,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ]
          ),
          padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
          child: PieChart(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
            PieChartData(
              sections: () {
                final Map<String, double> section = {};
                for(var transaction in _list!){
                  if(section.containsKey(transaction.type)){
                    section[transaction.type] = section[transaction.type]! + transaction.amount;
                  }else{
                    section[transaction.type] = transaction.amount.toDouble();
                  }
                }
                final colors = [Colors.lightBlueAccent, Colors.lightGreenAccent, Colors.redAccent];
                int colorIndex = 0;
                int index = -1;
                return section.entries.map((entry) {
                  final color = colors[colorIndex % 3];
                  index = index + 1;
                  final bool isSelected = index == touchIndex;
                  
                double enlarge = isSelected ? 70 : 50;
                  colorIndex++;
                  return PieChartSectionData(
                    color: color,
                    value : entry.value.toDouble(),
                    radius: enlarge,
                    showTitle: true,
                    title: '${entry.key}\n${entry.value.toStringAsFixed(0)}',
                    titleStyle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    borderSide: BorderSide(width: 0.5),
                    //add badgeWidget
                    titlePositionPercentageOffset: 0.58,
                  );
                }).toList();
              }(),
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                  setState(() {
                    if(response == null || event.isInterestedForInteractions || response.touchedSection == null){
                      touchIndex = null;
                    }else{
                      touchIndex = response.touchedSection!.touchedSectionIndex;
                    }
                  });
                }
              ),
              centerSpaceRadius: 70,
              sectionsSpace: 10,
            ),
            
          ),
        ),
      )

      ]
    )
      
      
    );
            
  }

}
