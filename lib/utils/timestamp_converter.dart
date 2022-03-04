import 'package:cloud_firestore/cloud_firestore.dart';

String convertTimeStamp(Timestamp timestamp) {
  var timeStamp = timestamp.toDate();
  String time;
  if (timeStamp.minute.toString().length == 1) {
    time = timeStamp.hour.toString() + ":" + '0' + timeStamp.minute.toString();
  } else {
    time = timeStamp.hour.toString() + ":" + timeStamp.minute.toString();
  }
  return time;
}
