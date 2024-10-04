import 'package:flutter/material.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Despesas pesoais"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
            width: double.infinity,
            child: Card(
              child: Text("Grafico"),
              elevation: 5,
              color: Colors.blue,
            ),
          ),
          Container(
            width: double.infinity,
            child: Card(
              child: Text("Lista transações"),
              elevation: 5,
            ),
          )
        ]
      ),
    );
  }
}