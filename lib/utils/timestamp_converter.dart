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

String getDate(Timestamp timestamp) {
  var timeStamp = timestamp.toDate();
  String date;
  if (timeStamp.day.toString().length == 1) {
    date = '0' + timeStamp.day.toString();
  } else {
    date = timeStamp.day.toString();
  }
  if (timeStamp.month.toString().length == 1) {
    date = date + '/' + '0' + timeStamp.month.toString();
  } else {
    date = date + '/' + timeStamp.month.toString();
  }
  date = date + '/' + timeStamp.year.toString();
  return date;
}