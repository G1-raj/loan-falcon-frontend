//import 'package:intl/intl.dart';

List<String> calculateEmiDates(String loanStartDate, String loanDurationMonths, String emiAmount) {
  
  List<String> emiDates = [];
  int loanDuration = int.parse(loanDurationMonths);
  //double _emiAmount = double.parse(emiAmount);


  DateTime currentEmiDate = DateTime.parse(loanStartDate);

  for (int i = 0; i < loanDuration; i++) {
  
    emiDates.add(currentEmiDate.toIso8601String());

    currentEmiDate = currentEmiDate.add(const Duration(days: 30));
  }

  return emiDates;
}