import 'package:flutter/material.dart';
import 'package:firstapp/database.dart';


class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}
class Transaction{
  DateTime? date;
  int amount;
  bool credit;
  String? type;
  String? note;
  //Constructor

  Transaction({
    required this.amount,
    required this.credit,
    this.type,
    this.note,
    this.date,
    
  });
}

class _InputState extends State<Input> {
  final DatabaseService? _transactions = DatabaseService.instance;
  DateTime? selectedDate;
  int _amount = 0;
  bool _credit = true;
  String? _type = "";
  String? note = "";
  Transaction? transaction;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 15, top: 25),
          child: const Text(
            'Input',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  onChanged:(value){setState(() {
                    _amount = int.parse(value);
                  });},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Amount',
                  ),
                ),
              ),
              Row(
                children: [
                  Text('D'),
                  Switch(value: _credit, onChanged: (value){
                    setState(() {
                      _credit = value;
                    });
                  }),
                  Text('C'),
                  Text('Date: '),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2050),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      selectedDate == null
                          ? 'Select Date'
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownMenu(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      initialSelection: null,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: 'Food', label: 'Food'),
                        DropdownMenuEntry(value: 'Petrol', label: 'Petrol'),
                        DropdownMenuEntry(value: 'Shopping', label: 'Shopping'),
                      ],
                      onSelected: (value){
                        setState(() {
                          _type = value;
                        });
                      },
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => {
                      _dialogBuilder(context),
                      
                    },
                    child: const Text('Note...'),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => {
                  setState(() {
                    transaction = Transaction(
                    amount: _amount,
                    credit: _credit,
                    date: selectedDate,
                    type: _type,
                    note: note,
                    );
                  }
                  
                  ),
                
                    _transactions!.addTransaction(transaction!.amount, transaction!.date ?? DateTime.now(), transaction!.credit, transaction!.type ?? "", transaction!.note ?? ""),    
                  
                  print("Transaction: $transaction, ${transaction?.amount}, ${transaction?.credit}, ${transaction?.date}, ${transaction?.type}, ${transaction?.note}"),
                },
                child: const Text('ADD TRANSACTION'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Future<void> _dialogBuilder(BuildContext context) {
  String temp = note ?? "";
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Note: '),
        content: TextField(
          decoration: const InputDecoration(hintText: "Enter Note..."),
          onChanged: (value){
            setState(() {
              temp = value;
            });
          },
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              note = temp;
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
}


