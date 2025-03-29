import 'package:flutter/material.dart';
import 'package:firstapp/database.dart' as db;

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final db.DatabaseService _transactions = db.DatabaseService.instance;
  List<db.Transaction>? _list;
  Future<void> fetchTransactions() async {
    List<db.Transaction> temp = await _transactions.getTransactions();
    setState(() {
      _list = temp;
    });
  }

  void initState() {
    super.initState();
    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(15),
          child: const Text(
            'Transactions',
            
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          ),
          Expanded(
            child:
                _list == null
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: _list!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          color: Colors.pink,
                          child: Center(
                            child: Column(  
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID: ${_list![index].id}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                Text("Amount: ${_list![index].amount}"),
                                Text("Type: ${_list![index].type}"),
                                Text("Date: ${_list![index].date}"),
                                Text("Note: ${_list![index].note}"),
                                TextButton(onPressed: null, child: Text('Delete')),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
