import 'package:flutter/material.dart';
import 'package:splitsnap/models/transaction.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.tnc,
    required this.isCredit,
    required this.balance,
  });

  Tnc tnc;
  bool isCredit;
  double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
        color: isCredit ? Colors.green : Colors.red,
      ),
      child: Row(
        children: [
          // Details
          Flexible(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // time
                  Text(
                    DateFormat.MMMd().add_jm().format(tnc.time.toDate()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  // Balance
                  Text(
                    " \u{20B9} ${(balance).abs()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Description
                  Text(
                    tnc.description,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isCredit == true
                      ? const Text(
                          "You Got",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const Text(
                          "You Gave ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  Text(
                    ' \u{20B9} ${tnc.amount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
