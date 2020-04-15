import 'package:intl/intl.dart';

formatDate(date) {
  var number = int.parse(date);
  assert(number is int);
  var formattedDate = DateTime.fromMillisecondsSinceEpoch(number);
  var doubleformattedDate = DateFormat.yMMMMEEEEd().format(formattedDate);
  return doubleformattedDate;
}
