import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight;
  double? _deviceWidth;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;

  File? _image;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleWidget(),
                _profileImageWidget(),
                _registrationForm(),
                _registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return const Text(
      'Finstagram',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _registerButton() {
    return MaterialButton(
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: _registerUser,
      minWidth: _deviceWidth! * 0.70,
      height: _deviceHeight! * 0.06,
      color: Colors.red,
      child: const Text(
        'Register',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _registrationForm() {
    return SizedBox(
      height: _deviceHeight! * 0.30,
      width: _deviceWidth! * 0.70,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameField(),
            _emailTextField(),
            _passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: 'Name...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      onSaved: (value) {
        setState(() {
          _name = value;
        });
      },
      validator: (value) => value!.isNotEmpty ? null : 'Please enter a Name ',
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: 'Email...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
      validator: (value) {
        bool result = value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return result ? null : 'Please enter a valid email';
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
      validator: (value) {
        return value!.length > 6
            ? null
            : 'Password must be more than 6 character';
      },
    );
  }

  Widget _profileImageWidget() {
    var _imageProvider = _image != null
        ? FileImage(_image!)
        : const NetworkImage('https://i.pravatar.cc/300');
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((_result) {
          setState(() {
            _image = File(_result!.files.first.path!);
          });
        });
      },
      child: Container(
        height: _deviceHeight! * 0.20,
        width: _deviceWidth! * 0.20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _imageProvider as ImageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void _registerUser() {
    if (_registerFormKey.currentState!.validate() && _image != null) {
      print('valid!');
      _registerFormKey.currentState!.save();
    }
  }
}
