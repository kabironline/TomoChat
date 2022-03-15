//Function Used to convert a List<dynamic> to a List<string>
List<String> dynamic2StringList(List<dynamic> list) {
  List<String> stringList = [];
  for (var item in list) {
    stringList.add(item.toString());
  }
  return stringList;
}