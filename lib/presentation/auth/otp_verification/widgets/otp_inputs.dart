import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:prestahub/core/constants/app_constants.dart';

class OtpInputs extends StatefulWidget {
  const OtpInputs({super.key});

  @override
  State<OtpInputs> createState() => _OtpInputsState();
}

class _OtpInputsState extends State<OtpInputs> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  final int length = 6;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(length, (index) => FocusNode());
    _controllers = List.generate(length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Logic for pasting a code
      final digits = value.split('').where((char) => RegExp(r'\d').hasMatch(char)).toList();
      
      for (var i = 0; i < digits.length && (index + i) < length; i++) {
        _controllers[index + i].text = digits[i];
      }
      
      // Move focus to the next empty field or the last filled one
      int nextIndex = index + digits.length;
      if (nextIndex >= length) nextIndex = length - 1;
      FocusScope.of(context).requestFocus(_focusNodes[nextIndex]);
      return;
    }

    if (value.isNotEmpty) {
      if (index < length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
        // Simulation d'une auto-validation et redirection
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            context.push(AppConstants.routeNewPassword);
          }
        });
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    // Stitch based colors
    final bgUnfocused = isDark ? Colors.grey[800] : Colors.grey[50];
    final bgFocused = isDark ? Colors.grey[800] : Colors.white;
    final borderUnfocused = isDark ? Colors.grey[700]! : Colors.grey[200]!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.backspace) {
                   if (_controllers[index].text.isEmpty && index > 0) {
                     FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                     _controllers[index - 1].clear();
                   }
                }
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (value) => _onChanged(value, index),
              // Remove maxLength to allow detecting pasted string longer than 1 char
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
              inputFormatters: [
                // We don't use LengthLimitingTextInputFormatter here because we want to handle the paste
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                counterText: '',
                hintText: '-',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                ),
                filled: true,
                fillColor: _focusNodes[index].hasFocus ? bgFocused : bgUnfocused,
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderUnfocused, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
