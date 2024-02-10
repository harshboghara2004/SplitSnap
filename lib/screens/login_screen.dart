import 'package:flutter/material.dart';
import 'package:splitsnap/resources/auth_methods.dart';
import 'package:splitsnap/screens/home_screen.dart';
import 'package:splitsnap/screens/register_screen.dart';
import 'package:splitsnap/utils/dialogs.dart';
import 'package:splitsnap/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    if (_emailController.text.isEmpty) {
      Dialogs().simpleDialog('Field is empty!', 'Email can not be empty');
      return;
    }
    if (_passwordController.text.isEmpty) {
      Dialogs().simpleDialog('Field is empty!', 'Password can not be empty');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      Dialogs().simpleDialog(res, 'Try Again.');
    }
  }

  void navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplitSnap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              child: TextFieldInput(
                hintText: 'Email',
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: TextFieldInput(
                hintText: 'Password',
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                isPass: true,
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FilledButton(
                    onPressed: loginUser,
                    child: const Text(
                      'Log IN',
                    ),
                  ),
            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToRegister,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
