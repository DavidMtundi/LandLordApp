import 'package:flutter/material.dart';
import 'package:landlord/validators/validator.dart';

class EditText extends StatefulWidget {
  String title;
  TextEditingController textEditingController;
  TextInputType inputType = TextInputType.text;
  bool isPassword = false;
  String? Function(String?) formvalidator;
  String errortxt;
  EditText(
      {Key? key,
      this.errortxt = "Field cannot be empty",
      required this.title,
      this.formvalidator = geterror,
      this.isPassword = false,
      required this.textEditingController,
      this.inputType = TextInputType.text})
      : super(key: key);

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
      child: TextFormField(
        validator: widget.formvalidator,
        style: const TextStyle(fontSize: 13),
        obscureText: widget.isPassword,
        textAlign: TextAlign.center,
        controller: widget.textEditingController,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          fillColor: Theme.of(context).dividerColor,
          hintText: widget.title,
          hintStyle: Theme.of(context).textTheme.headline3,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
