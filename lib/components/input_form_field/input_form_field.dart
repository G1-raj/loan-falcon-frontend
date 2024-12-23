import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputFormField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final Icon fieldIcon;
  bool? hidePassword;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Function? onChanged;

  InputFormField({
    super.key,
    required this.title,
    required this.controller,
    this.hidePassword = false,
    required this.fieldIcon,
    this.validator,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  bool _hidePassword = false;

  @override
  void initState() {
    super.initState();
    _hidePassword = widget.hidePassword ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        readOnly: widget.readOnly,
        controller: widget.controller,
        obscureText: _hidePassword,
        validator: widget.validator,
        onChanged: widget.onChanged as void Function(String)?,
        decoration: InputDecoration(
          prefixIcon: widget.fieldIcon,
          suffixIcon: widget.hidePassword == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  child: Icon(
                    _hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          hintText: "Enter your ${widget.title.toLowerCase()}",
          labelText: widget.title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
