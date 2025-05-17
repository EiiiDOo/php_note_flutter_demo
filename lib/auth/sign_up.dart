import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:php_note_demo/components/crud.dart';
import 'package:php_note_demo/components/custom_dialog.dart';
import 'package:php_note_demo/components/custom_text_form_field.dart';
import 'package:php_note_demo/components/valid.dart';
import 'package:php_note_demo/constant/link_api.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
    emailField = TextEditingController();
    passField = TextEditingController();
    usernameField = TextEditingController();
  }

  @override
  void dispose() {
    if (emailField != null) emailField?.dispose();
    if (passField != null) passField?.dispose();
    if (usernameField != null) usernameField?.dispose();
    super.dispose();
  }

  final Crud _crud = Crud();
  TextEditingController? emailField;
  TextEditingController? usernameField;
  TextEditingController? passField;
  GlobalKey<FormState> formState = GlobalKey();

  signUp() async {
    if (formState.currentState!.validate()) {
      final payload = {
        'username':
            usernameField?.text.isEmpty ?? false ? null : usernameField?.text,
        'email': emailField?.text.isEmpty ?? false ? null : emailField?.text,
        'password': passField?.text.isEmpty ?? false ? null : passField?.text,
      };
      final res = await _crud.postRequest(linkSignUp, payload);
      if (res == null) {
        customDialog(
          context,
          'Error',
          'postRequest returned: $res',
          dismissible: true,
        );
        return;
      }
      if (res?['status'] == 'success') {
        customDialog(
          context,
          'Success',
          "Now you can sign In.",
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/sign-in',
                  (route) => false,
                );
              },
              child: Text('Sign In'),
            ),
          ],
        );
        return;
      } else {
        customDialog(
          context,
          'Error',
          '⚠️ signUp failed: ${res?['status']}',
          dismissible: true,
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Image.asset(
            '',
            width: 400,
            height: 300,
            errorBuilder:
                (context, error, stackTrace) => Icon(Icons.logout, size: 200),
          ),
          Form(
            key: formState,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                CustomTextFormField(
                  valid: (val) => validInput(val, 3, 20),
                  hint: 'Username',
                  textEditingController: usernameField!,
                ),
                CustomTextFormField(
                  valid: (val) => validInput(val, 5, 40),
                  hint: 'Email',
                  textEditingController: emailField!,
                ),
                CustomTextFormField(
                  valid: (val) => validInput(val, 3, 10),
                  hint: 'Password',
                  textEditingController: passField!,
                ),
                MaterialButton(
                  onPressed: () async {
                    bool? res = await signUp();
                    if (res == true) {
                      customDialog(
                        context,
                        'Success',
                        "Now you can sign In.",
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/sign-in',
                                (route) => false,
                              );
                            },
                            child: Text('Sign In'),
                          ),
                        ],
                      );
                    } else {}
                  },
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Text('Sign Up'),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/sign-in',
                      (route) => false,
                    );
                  },
                  child: Text('Sign In'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
