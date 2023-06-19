import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

class CustomTextFormField extends StatelessWidget {
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? prefixIcon;
  final String? initialValue;
  final Widget? suffixIcon;
  final String? title;
  final String? errorText;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final double borderWidth;
  final TextStyle? style;
  final TextCapitalization textCapitalization;
  final double radius;
  final InputDecoration? decoration;
  final int? maxLength;
  final void Function(String?)? onSaved;

  const CustomTextFormField({
    super.key,
    this.title,
    this.hintText,
    this.onChanged,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.textInputType = TextInputType.text,
    this.onEditingComplete,
    this.textInputAction,
    this.inputFormatters,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.errorText,
    this.decoration,
    this.style,
    this.onSaved,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.radius = 20,
    this.focusNode,
    this.borderWidth = 1,
    this.enabled = true,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return title != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title!, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: kDefaultSpacing / 2),
              form(context)
            ],
          )
        : form(context);
  }

  TextFormField form(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      obscureText: obscureText,
      validator: validator,
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: textInputType,
      onSaved: onSaved,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      maxLength: maxLength,
      readOnly: readOnly,
      onEditingComplete: onEditingComplete,
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
        hintText: hintText,
        errorText: errorText,
        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red,
            ),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF969A9D),
            ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide:
                BorderSide(color: const Color(0xFF707070), width: borderWidth)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide:
                BorderSide(color: const Color(0xFF707070), width: borderWidth)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide:
                BorderSide(color: const Color(0xFF707070), width: borderWidth)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(color: Colors.red, width: borderWidth),
        ),
      ).copyWith(
        prefixIconConstraints: decoration?.prefixIconConstraints,
        prefix: decoration?.prefix,
        prefixText: decoration?.prefixText,
        prefixStyle: decoration?.prefixStyle,
        suffix: decoration?.suffix,
        suffixText: decoration?.suffixText,
        suffixStyle: decoration?.suffixStyle,
        counter: decoration?.counter,
        counterText: decoration?.counterText,
        counterStyle: decoration?.counterStyle,
        filled: decoration?.filled,
        fillColor: decoration?.fillColor,
        focusColor: decoration?.focusColor,
        hoverColor: decoration?.hoverColor,
        errorStyle: decoration?.errorStyle,
        errorBorder: decoration?.errorBorder,
        focusedBorder: decoration?.focusedBorder,
        enabledBorder: decoration?.enabledBorder,
        border: decoration?.border,
        contentPadding: decoration?.contentPadding,
        isDense: decoration?.isDense,
      ),
      style: style ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}
