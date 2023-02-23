import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:beamer/beamer.dart';
import 'package:research_buddy/providers/progress_provider.dart';
import 'package:research_buddy/views/helpers/snackbar_messages.dart';
import 'package:research_buddy/views/helpers/progress_overlay.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Research Buddy Login"), backgroundColor: Colors.blue,),
      body: ProgressOverlay(child: LoginPageForm()),
    );
  }
}

class LoginPageForm extends ConsumerWidget {
  final _loginImage =
      "https://media.istockphoto.com/id/1125711770/vector/literature-and-digital-culture-vector-of-people-reading-books-using-modern-technology.jpg?s=612x612&w=0&k=20&c=Ol7dQW6EnUcQWlB7HG4cHnBpiO8Gk28rbNiPzZn9OKQ=";
  final _formKey = GlobalKey<FormBuilderState>();

  LoginPageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Image.network(_loginImage),
                SizedBox(height: 20),
                const Text(
                  "Research Buddy",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30, fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    label: Text('Email Address'),
                    prefixIcon: Icon(Icons.email),
                    labelStyle: TextStyle(color: Colors.black87),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.email(context),
                      FormBuilderValidators.required(context),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                    prefixIcon: Icon(Icons.lock),
                    labelStyle: TextStyle(color: Colors.black87),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  ),
                ),
              ],
            ),
          ),
          //const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _handleSubmit(context, ref),
                  child: const Text("Submit"),
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(100.0, 50.0)),
                      backgroundColor: MaterialStateProperty.resolveWith((states) =>
                      states.contains(MaterialState.pressed) ? Colors.white : Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    )
                  ),
                ),
                TextButton(
                  onPressed: () => _handleRegister(context),
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleRegister(BuildContext context) {
    Beamer.of(context).beamToNamed('/register');
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) return;
    formState.save();

    final String email = formState.value['email'];
    final String password = formState.value['password'];

    final progressNotifier = ref.read(progressProvider.notifier);
    progressNotifier.start();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Beamer.of(context).beamToNamed('/home');
    } on FirebaseAuthException catch (e) {
      showErrorMessage(context, e.message ?? 'Something went wrong!');
    } catch (e) {
      showErrorMessage(context, 'Something went wrong!');
    } finally {
      progressNotifier.stop();
    }
  }
}
