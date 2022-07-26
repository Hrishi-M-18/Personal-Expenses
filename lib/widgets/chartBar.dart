import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spentAmount;
  final double percentOfTotalAmount;

  ChartBar(this.label, this.spentAmount, this.percentOfTotalAmount);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.15,
              //fixed height because the bar starts a bit earlier than the
              //other ones if it shrinks due to bigger value of amount
              child: FittedBox(
                child: Text(
                  '\₹${spentAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.60,
              width: 15,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: percentOfTotalAmount,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(214, 0, 179, 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.15,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
