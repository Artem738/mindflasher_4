import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

List<List<String>> parseHtmlTable(String htmlData) {
  // Парсим HTML строку
  Document document = parse(htmlData);

  // Находим таблицу
  Element? table = document.querySelector('table.waffle');
  if (table == null) return [];

  // Парсим строки таблицы
  List<List<String>> parsedData = [];
  for (Element row in table.querySelectorAll('tr')) {
    List<String> rowData = [];
    for (Element cell in row.querySelectorAll('td')) {
      rowData.add(cell.text.trim());
    }
    if (rowData.isNotEmpty) {
      parsedData.add(rowData);
    }
  }

  return parsedData;
}