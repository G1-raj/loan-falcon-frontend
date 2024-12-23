List<String> formatDateList(List<String> dateStrings) {
  return dateStrings.map((dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }).toList();
}