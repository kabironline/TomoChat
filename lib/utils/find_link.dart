///Finding all the links in a String and returning a List of them.
/// After it Identifies the link it will return a list where the links are sperated from the text.
/// Example:
/// text: "Hello there https://www.google.com/ this is a link"
/// returns: ["Hello there ", "https://www.google.com/", " this is a link"]
/// If no link is found it will return the text.

List<String>? findLinks(String text) {
  var link = RegExp(r'(?:https?|ftp)://[-a-zA-Z0-9+&@#/\-%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]');
  var matches = link.allMatches(text);
  if (matches.isEmpty) {
    return null;
  }
  List<String> links = [];
  for (var i = 0; i < matches.length; i++) {
    var match = matches.elementAt(i);
    var matchNext = i < matches.length - 1 ? matches.elementAt(i + 1) : null;

    if (matchNext != null && match.start == matchNext.start) {
      links.add(text.substring(match.start, matchNext.end));
      i++;
    } else {
      links.add(text.substring(match.start, match.end));
    }
  }
  return links;
}

//Find links using the findLinks function then substitute the link with an empty string.
//if no link is found it will return false.
//If there are links check if there is text other than the link then return false.
//If there is no text other than the link then return true.
bool isOnlyLink(String text) {
  var link = RegExp(r'(?:https?|ftp)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]');
  var matches = link.allMatches(text);
  if (matches.isEmpty) {
    return false;
  }
  var temp = text.replaceAllMapped(link, (match) => "").trim();
  if (temp.isEmpty){
    return true;
  }
  return false;
}
bool isImageLink (String text) {
  var checker = RegExp(r'(?:([^:/?#]+):)?(?://([^/?#]*))?([^?#]*\.(?:jpg|jpeg|gif|png|webp|bmp))(?:\?([^#]*))?(?:#(.*))?');
  var matches = checker.allMatches(text);
  if (matches.isEmpty) {
    return false;
  }
  return true;
}
