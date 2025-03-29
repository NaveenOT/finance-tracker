import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
   return Container(
      alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 15, top: 25),
                child: const Text('Dashboard',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                ),         
    );
            
  }
}
