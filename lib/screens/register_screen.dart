import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splitsnap/resources/auth_methods.dart';
import 'package:splitsnap/screens/login_screen.dart';
import 'package:splitsnap/utils/dialogs.dart';
import 'package:splitsnap/utils/pickImage.dart';
import 'package:splitsnap/widgets/text_field_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  final imageUrl =
      'https://t4.ftcdn.net/jpg/00/64/67/27/360_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg';

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void registerUser() async {
    if (_usernameController.text.isEmpty) {
      Dialogs().simpleDialog('Field is empty!', 'Username can not be empty');
      return;
    }
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

    Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
            .buffer
            .asUint8List();

    _image ??= bytes;
    String res = await AuthMethods().registerNewUser(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else {
      Dialogs().simpleDialog(res, 'Try Again.');
    }
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
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
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://t4.ftcdn.net/jpg/00/64/67/27/360_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg',
                        ),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFieldInput(
              textEditingController: _usernameController,
              hintText: 'Username',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            // email input
            TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Email',
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            // password input
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Password',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FilledButton(
                    onPressed: registerUser,
                    child: const Text(
                      'Register',
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
