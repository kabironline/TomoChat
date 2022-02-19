import 'package:chat_app/modals/chat_modals.dart';
import 'package:chat_app/services/dm_conversations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<ChannelModel>> getUserChannels(String uid) async {
  var snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('channels')
      .get();
  if (snapshot.docs.isNotEmpty) {
    List<ChannelModel> channels = [];
    for (var doc in snapshot.docs) {
      var channelSnapshot =
          await getDMChannelFromId(doc.data()['conversationId']);
      channels.add(ChannelModel.fromDocument(channelSnapshot));
    }
    return channels;
  } else {
    return [];
  }
}
 