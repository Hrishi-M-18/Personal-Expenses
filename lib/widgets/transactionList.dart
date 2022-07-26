import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> myTransaction;
  final Function delTransaction;

  TransactionList(this.myTransaction, this.delTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.57,
      //required to set height limit for ListView.builder()
      child: myTransaction.isEmpty
          ? LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Text(
                    'No transactions added yet!',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      height: constraints.maxHeight * 0.8,
                      child: Image.asset(
                        'assets/images/khabyLame2.png',
                        fit: BoxFit.fitHeight,
                      )),
                ],
              );
            })
          : ListView.builder(
              itemCount: myTransaction.length,
              itemBuilder: (cntxt, index) {
                return Card(
                  color: Theme.of(context).accentColor,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).accentColor,
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            '\₹ ${myTransaction[index].amount.toStringAsFixed(0)}',
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      myTransaction[index].title,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('dd MMMM, yyyy')
                          .format(myTransaction[index].date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => delTransaction(myTransaction[index].id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
