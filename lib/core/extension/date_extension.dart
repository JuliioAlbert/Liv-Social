import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  static final DateFormat _dateFormatyyyyMMddHHmm =
      DateFormat('yyyy-MM-dd HH:mm');

  String formatyyyyMMddHHmm() => _dateFormatyyyyMMddHHmm.format(this);
}
