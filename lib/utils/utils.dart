

class Utils{
  Utils._();
  static String formatDateToDayMonthYear(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0'); // Gün (01, 02, ...)
    String month = dateTime.month.toString().padLeft(2, '0'); // Ay (01, 02, ...)
    String year = dateTime.year.toString(); // Yıl

    return "$day/$month/$year"; // "gün/ay/yıl" formatında birleştirme
  }

}