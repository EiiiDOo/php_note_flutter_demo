import 'package:flutter/material.dart';
import 'package:php_note_demo/components/crud.dart';
import 'package:php_note_demo/components/custom_dialog.dart';
import 'package:php_note_demo/components/custom_text_form_field.dart';
import 'package:php_note_demo/components/valid.dart';
import 'package:php_note_demo/constant/link_api.dart';
import 'package:php_note_demo/main.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    super.initState();
    emailField = TextEditingController();
    passField = TextEditingController();
  }

  @override
  void dispose() {
    if (emailField != null) emailField?.dispose();
    if (passField != null) passField?.dispose();
    super.dispose();
  }

  TextEditingController? emailField;
  TextEditingController? passField;
  GlobalKey<FormState> formState = GlobalKey();
  final Crud _crud = Crud();

  signIn() async {
    if (formState.currentState!.validate()) {
      loadingDialog(context);
      var payload = {
        'email': emailField?.text.isEmpty ?? false ? null : emailField?.text,
        'password': passField?.text.isEmpty ?? false ? null : passField?.text,
      };
      var res = await _crud.postRequest(linkSignIn, payload);
      Navigator.pop(context);
      if (res == null) {
        customDialog(
          context,
          'Error',
          'postRequest returned: $res',
          dismissible: true,
        );
        return;
      }
      if (res['status'] == 'success') {
        await sharedPreferences.setString('id', res['data']['id'].toString());
        await sharedPreferences.setString(
          'email',
          res['data']['email'].toString(),
        );
        await sharedPreferences.setString(
          'username',
          res['data']['username'].toString(),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        customDialog(
          context,
          'Error',
          '⚠️ Sign In status: ${res['status']}',
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
        title: Text("Sign In"),
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
                (context, error, stackTrace) => Icon(Icons.login, size: 200),
          ),
          Form(
            key: formState,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                CustomTextFormField(
                  valid: (val) => validInput(val, 3, 40),
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
                    await signIn();
                  },
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Text('Sign In'),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/sign-up',
                      (route) => false,
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
