import 'package:flutter/material.dart';
import 'package:splitsnap/resources/fire_store_methods.dart';
import 'package:splitsnap/utils/dialogs.dart';
import 'package:splitsnap/widgets/text_field_input.dart';

// ignore: must_be_immutable
class AddTranscationScreen extends StatefulWidget {
  AddTranscationScreen({
    super.key,
    required this.from,
    required this.to,
  });

  String from;
  String to;

  @override
  State<AddTranscationScreen> createState() => _AddTranscationScreenState();
}

class _AddTranscationScreenState extends State<AddTranscationScreen> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
    _description.dispose();
  }

  makeTranscation() async {
    try {
      double amt = double.parse(_amount.text);
      String desc = _description.text;

      if (desc.isEmpty) {
        desc = 'No Description';
      }

      await FireStoreMethods().addTranscation(
        from: widget.from,
        to: widget.to,
        amount: amt,
        description: desc,
      );
    } catch (e) {
      Dialogs().simpleDialog('Something went wrong', e.toString());
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitSnap'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  flex: 2,
                  child: Text(
                    '\u{20B9}',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: TextFieldInput(
                    textEditingController: _amount,
                    textInputType: TextInputType.number,
                    hintText: 'Enter Amount',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: TextFieldInput(
                textEditingController: _description,
                textInputType: TextInputType.text,
                hintText: 'Enter Description',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: makeTranscation,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 10,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 50),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
