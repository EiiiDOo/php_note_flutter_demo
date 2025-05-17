import 'package:php_note_demo/constant/messages.dart';

validInput(String? val, int min, int max) {
  if (val!.isEmpty) {
    return MESSAGE_INPUT_EMPTY;
  } else if (val.length > max) {
    return '$MESSAGE_INPUT_MAX$max';
  } else if (val.length < min) {
    return '$MESSAGE_INPUT_MIN$min';
  }
}
