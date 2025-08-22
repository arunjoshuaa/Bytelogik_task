import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
            labelText: widget.label,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _toggleVisibility,
            ),
          ),
        ),
        if (widget.hint != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.hint!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
