import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chartBar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues
  //get retrieves a particular class field and save it in a variable or object
  {
    return List.generate(7, (index) {
      // 'generate' gets the items from the list within the given constraints
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      //gives past 1 week from today by subtracting days
      double totalPerDaySum = 0;

      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalPerDaySum += recentTransactions[i].amount;
        }
      }
      ;

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalPerDaySum,
      };
    }).reversed.toList();
    //we use reverse, so that the we have the older day to the left
  }

  double get totalWeekSpent {
    return groupedTransactionValues.fold(0.0, (sum, element) {
      //fold() -> used to change list to another type with the logic we assign.
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //height: MediaQuery.of(context).size.height * 0.43,
      child: Card(
        margin: EdgeInsets.all(5),
        color: Theme.of(context).primaryColor,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalWeekSpent == 0
                      ? 0.0
                      : (data['amount'] as double) / totalWeekSpent,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
