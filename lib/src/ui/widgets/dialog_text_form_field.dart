import 'package:flutter/material.dart';

class DialogTextFormField extends StatefulWidget {
  final String title;
  final String? labelText;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final void Function()? onSave;

  const DialogTextFormField(this.title,
      {Key? key, this.labelText, this.obscureText, this.validator,
        this.inputType, this.controller, this.onSave})
      : super(key: key);

  @override
  State<DialogTextFormField> createState() => _DialogTextFormFieldState();
}

class _DialogTextFormFieldState extends State<DialogTextFormField> {
  final _formKey = GlobalKey<FormState>();
  bool _isValidated = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        onChanged: () => setState(() => _isValidated = _formKey.currentState!.validate()),
        child: TextFormField(
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          keyboardType: widget.inputType,
          obscureText: widget.obscureText ?? false,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: widget.labelText,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isValidated ? widget.onSave : null,
          child: const Text('Save'),
        )
      ],
    );
  }
}
