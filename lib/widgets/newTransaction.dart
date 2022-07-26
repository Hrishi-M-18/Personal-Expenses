import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  //This is StatefulWidget so that it can store the values we enter.
  //In StatelessWidget, when it re-evaluates the data stored are lost.
  Function addTnx;

  NewTransaction(this.addTnx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _inputTitle = TextEditingController();
  final _inputAmount = TextEditingController();
  DateTime _selectedDate;

  void _data() {
    if (_inputAmount.text.isEmpty) {
      return;
    }
    final enteredText = _inputTitle.text;
    final enteredAmount = double.parse(_inputAmount.text);

    if (enteredText.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTnx(enteredText, enteredAmount, _selectedDate);
    // 'widget.' is added here to access the 'Function addTnx'
    //in line 7 of the widget class. ->now we are in state class

    Navigator.of(context).pop();
    //to close the modalSheet once we submit the details
    //context gives access to the context of the widget
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((chosenDate) {
      // 'then' is a future method that lets user to select in the future
      if (chosenDate == null) {
        return;
      }
      setState(() {
        _selectedDate = chosenDate;
      });
      // Runs the build again with the selected date
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          //for the customization of modal sheet due to overlapping of soft keyboard
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //Threw RenderFlex error, so changed 'resizeToAvoidBottomInset = false' in Scaffold
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'For what you spent the money?',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                  ),
                ),
                cursorColor: Theme.of(context).accentColor,
                controller: _inputTitle,
                onSubmitted: (_) => _data(),
                //we have to manually trigger the fn data, as we used anonymous fn
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'How much did you spend?',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                  ),
                ),
                cursorColor: Theme.of(context).accentColor,
                controller: _inputAmount,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _data(),
                //we have to manually trigger the fn data, as we used anonymous fn
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date chosen'
                            : 'Date: ${DateFormat('dd MMMM').format(_selectedDate)}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Expanded() -> Flexible() with flexFit.tight
                    TextButton(
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).accentColor),
                onPressed: _data,
                //here we just give the reference of data fn
              ),
            ],
          ),
        ),
      ),
    );
  }
}
