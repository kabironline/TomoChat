import 'package:chat_app/utils/validation_builder.dart';
import 'package:chat_app/widgets/text_input_container.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late String emailValue;

  @override
  var store = Localstore.instance;
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: store.collection('emails').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data.toString());
                  }
                  return CircularProgressIndicator();
                },
              ),
              TextInputContainer(
                trailing: null,
                icon: Icons.alternate_email,
                width: 100,
                heading: const Text("Email Address"),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  validator: ValidationBuilder().email().build(),
                  onChanged: (value) => emailValue = value,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Type a message',
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    store.collection('email').doc().set({
                      'email': emailValue,
                    });
                  },
                  child: const Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
