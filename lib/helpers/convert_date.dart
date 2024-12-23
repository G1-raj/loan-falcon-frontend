String convertDateToMongoDBFormat(DateTime date) {
  return date.toUtc().toIso8601String();
}