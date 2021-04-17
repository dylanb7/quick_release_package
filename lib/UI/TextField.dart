part of '../quick_release_package.dart';


class UITextField extends StatefulWidget {
  final TextEditingController controller;

  final BuildContext context;

  final String placeholder;

  final double borderRad;

  final List<String> autoFill;

  final List<TextInputFormatter> inputFormatters;

  final Icon prefix;

  final Function(String) prefixFunc;

  UITextField(this.controller, this.context, this.borderRad, this.placeholder,
      {List<String> autoFill = const [],
      List<TextInputFormatter> inputFormatters = const [],
      Icon prefix,
      Function(String) prefixFunc})
      : this.autoFill = autoFill,
        this.prefix = prefix,
        this.prefixFunc = prefixFunc,
        this.inputFormatters = inputFormatters;

  @override
  State<StatefulWidget> createState() {
    return _UITextFieldState();
  }
}

class _UITextFieldState extends State<UITextField> {
  @override
  Widget build(BuildContext context) {
    return Card(child: TextField(
      controller: widget.controller,
      onChanged: (value) {
        setState(() {});
      },
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autoFill,
      decoration: InputDecoration(
        labelText: widget.placeholder,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRad)),
        prefixIcon: widget.prefix != null
            ? IconButton(
                icon: widget.prefix,
                onPressed: widget.prefixFunc ?? () {},
              )
            : null,
        suffixIcon: widget.controller.text.length == 0
            ? null
            : IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  widget.controller.clear();
                  setState(() {});
                }),
      ),
    ));
  }
}
