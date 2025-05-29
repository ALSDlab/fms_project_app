import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_textfield/currency_textfield.dart';

FilteringTextInputFormatter allValues =
FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

class CurrencyInputField extends StatefulWidget {
  const CurrencyInputField({
    super.key,
    required this.controller,
    this.formatter,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.number,
    this.validator,
    this.hint,
    this.width = 300,
    this.hidden = false,
    this.onEditingComplete,
    this.clearButton = false,
    this.onTap,
    this.maxLines = 1,
    this.borderRadius = 15,
    this.elevation = 0.5,
    this.onChanged,
    style,
    this.showHint = true,
    this.enabled = true,
    this.textAlign = TextAlign.center,
    this.disabledColor,
    this.textCapitalization,
    this.currencySymbol = '€', // 통화 기호 (기본값 유로)
    this.locale = 'de_DE',     // 로케일 (기본값 독일)
  }) : style = style ?? const TextStyle(fontSize: 16);

  final TextEditingController controller;
  final dynamic formatter;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final String? hint;
  final double width;
  final bool hidden;
  final Function? onEditingComplete;
  final bool clearButton;
  final Function? onTap;
  final int? maxLines;
  final double borderRadius;
  final double elevation;
  final TextStyle style;
  final Function(String)? onChanged;
  final bool showHint;
  final bool enabled;
  final TextAlign textAlign;
  final Color? disabledColor;
  final TextCapitalization? textCapitalization;
  final String currencySymbol;
  final String locale;

  @override
  State<CurrencyInputField> createState() => _CurrencyInputFieldState();
}

class _CurrencyInputFieldState extends State<CurrencyInputField> {
  late CurrencyTextFieldController _currencyController;

  @override
  void initState() {
    super.initState();

    // CurrencyTextFieldController 초기화
    _currencyController = CurrencyTextFieldController(
      currencySymbol: widget.currencySymbol,
      decimalSymbol: ',',
      thousandSymbol: '.',
      numberOfDecimals: 2,
      initDoubleValue: 0.0,
    );

    // 원본 컨트롤러와 동기화
    _currencyController.addListener(() {
      // 순수 숫자 값만 원본 컨트롤러에 저장
      widget.controller.text = _currencyController.doubleValue.toString();

      if (widget.onChanged != null) {
        widget.onChanged!(_currencyController.doubleValue.toString());
      }
    });
  }

  @override
  void dispose() {
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Material(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        elevation: widget.elevation,
        child: TextFormField(
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          textAlign: widget.textAlign,
          enabled: widget.enabled,
          style: widget.style,
          maxLines: widget.maxLines,
          obscureText: widget.hidden,
          cursorColor: Colors.black,
          controller: _currencyController, // Currency 컨트롤러 사용
          autocorrect: false,
          keyboardType: widget.keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          onEditingComplete: widget.onEditingComplete as void Function()?,
          textInputAction: widget.textInputAction,
          onTap: widget.onTap as void Function()?,
          decoration: InputDecoration(
            labelText: widget.showHint ? widget.hint : null,
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            fillColor: Colors.grey[50],
            filled: true,
            // 테두리 제거
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorMaxLines: 3,
            suffixIcon: widget.clearButton
                ? Material(
              type: MaterialType.transparency,
              child: InkWell(
                canRequestFocus: false,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: const Icon(Icons.clear, color: Colors.grey, size: 20),
                onTap: () {
                  _currencyController.text = widget.currencySymbol;
                  widget.controller.clear();

                  if (widget.onChanged != null) {
                    widget.onChanged!('');
                  }
                },
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }
}