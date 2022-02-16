import 'package:chat_app/utils/validation_builder.dart';
import 'package:chat_app/widgets/text_input_container.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late String emailValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          ElevatedButton(onPressed: () {}, child: const Text("Submit")),
        ],
      ),
    );
  }
}
