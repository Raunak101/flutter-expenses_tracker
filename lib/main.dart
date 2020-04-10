import 'package:flutter/material.dart';
import 'package:new_vs/transaction_list.dart';
import './trans.dart';
import './new_trans.dart';
import './chart.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter app",
      theme: ThemeData(
        fontFamily: 'Quicksand',
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Transaction> usertransaction = [
    //Transaction(id: "T1", title: "Shoes", amount: 1000.0, date: DateTime.now()),
    //Transaction(
    //id: "T2", title: "Groceries", amount: 200.0, date: DateTime.now())
  ];

  void _addNew(String tx, double amt, DateTime choosendate) {
    final newTx = Transaction(
        title: tx,
        amount: amt,
        date: choosendate,
        id: DateTime.now().toString());
    setState(() {
      usertransaction.add(newTx);
    });
  }

  List<Transaction> get recentTransactions {
    return usertransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void addnew(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNew),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      usertransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.purple,
      title: Text("Expense Tracker"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => addnew(context),
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.25,
                child: Chart(recentTransactions)),
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.75,
                child: TransactionList(usertransaction, _deleteTransaction)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[700],
        hoverColor: Colors.black,
        child: IconButton(
            color: Colors.black,
            icon: Icon(Icons.add),
            onPressed: () => addnew(context)),
      ),
    );
  }
}
