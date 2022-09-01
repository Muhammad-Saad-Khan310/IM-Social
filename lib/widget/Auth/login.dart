import 'package:flutter/material.dart';
import 'package:im_social/screen/loginScreen.dart';
import 'package:im_social/screen/signupScreen.dart';
import 'package:im_social/widget/Auth/signup.dart';

class Login extends StatefulWidget {
  // const Login({super.key});

  Login(this.submitfn, this.isLoading);

  final void Function(
    String email,
    String password,
    BuildContext ctx,
  ) submitfn;
  final bool isLoading;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    _formKey.currentState!.save();
    widget.submitfn(email.trim(), password.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 120),
        child: Column(
          children: [
            const Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Email",
                      icon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Email";
                      }
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Password",
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Password";
                      }
                    },
                    onSaved: (newValue) {
                      password = newValue!;
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignupScreen.routeName);
                      },
                      child: const Text("Don't have account yet?"),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: const Text("Login"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
