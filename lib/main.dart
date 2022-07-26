import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/newTransaction.dart';
import './widgets/transactionList.dart';
import './models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //to lock to the potrait mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //context contains the meta data of the widget tree
    return MaterialApp(
      title: 'My Expenses',
      theme: ThemeData(
        primaryColor: Color(0xffffa31a),
        accentColor: Color(0xff292929),
        scaffoldBackgroundColor: Color(0xff808080),
        errorColor: Color(0xff808080),
        fontFamily: 'Quicksand',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transaction = [
    //  Transaction(
    //    id: '1',
    //    title: 'juice',
    //    amount: 50,
    //    date: DateTime.now(),
    //  ),
  ];

  bool _showChart = true;
  //for the switch between the chart and list

  List<Transaction> get _recentTransactions
  //get retrieves a particular class field and save it in a variable or object
  {
    return _transaction.where((tnx) {
      return tnx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
    //'where' runs a function in every item in the list
    //and returns as required
  }

  double get totalWeekSpent {
    return _recentTransactions.fold(0.0, (sum, element) {
      //fold() -> used to change list to another type with the logic that we assign

      return sum + element.amount;
    });
  }
  //to show the total week spent in the card

  void _addMyTransaction(
      String tnxTitle, double tnxAmount, DateTime chosenDate) {
    final newTnx = Transaction(
      id: DateTime.now().toString(),
      title: tnxTitle,
      amount: tnxAmount,
      date: chosenDate,
    );
    //Getting the details from the user and adding in the list

    setState(() {
      _transaction.add(newTnx);
    });
    // Runs the build again to show the added transaction
  }

  void _startAddMyTransaction(BuildContext cntxt) {
    showModalBottomSheet(
        context: cntxt,
        backgroundColor: Theme.of(context).primaryColor,
        builder: (_) {
          return GestureDetector(
            //onTap: () {}, -> does nothing on tapping
            child: NewTransaction(_addMyTransaction),
            behavior: HitTestBehavior.opaque,
            //opaque means the entire size of the gesture detector is the hit region,
            //it doesn't stop the child from being hit.
          );
        });
  }

  void _deleteTransAction(String id) {
    setState(() {
      _transaction.removeWhere((element) => element.id == id);
    });
    // Runs the build again to show the list after deleting the transaction
  }

  @override
  //Context is a link to the location of a widget in the tree structure of widgets
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar =
        Platform.isIOS //PreferredSizeWidget because it
            //will show error in line 208 and 2 more
            ? CupertinoNavigationBar(
                middle: const Text(
                  'My Expenses',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Icon(CupertinoIcons.add_circled_solid),
                      onTap: () => _startAddMyTransaction(context),
                      // starts add my transaction
                    ),
                  ],
                ),
              )
            //if iOS it renders cupertino, else android appBar
            : AppBar(
                title: const Text(
                  'My Expenses',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: Colors.black87,
                      size: 30,
                    ),
                    onPressed: () => _startAddMyTransaction(context),
                  )
                ],
              );
    //appBar in variable because now the variable has the size of the appBar

    final pageBody = SafeArea(
      //SafeArea because chart is over-lapping with the appBar
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch.adaptive(
                  activeTrackColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Theme.of(context).accentColor,
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                    // Runs build with the changed boolean value
                  },
                ),
                Text(
                  'Show Chart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            _showChart
                ? Column(
                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.31,
                        child: Chart(_recentTransactions),
                      ),
                      Container(
                        //width: 325,
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.10,
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 5,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Past 7 days expense: \₹${totalWeekSpent.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.65,
                    child: TransactionList(_transaction, _deleteTransAction),
                  ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                //for iOS we are not rendering any button
                : FloatingActionButton(
                    child: Icon(
                      Icons.add_sharp,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
                    onPressed: () => _startAddMyTransaction(context),
                  ),
          );
  }
}
