import 'dart:ui';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/views/home_page.dart';
import 'package:TomoChat/widgets/bottom_sheet_tile.dart';
import 'package:flutter/material.dart';

Future GrpDetailBottomSheet(
    BuildContext context, UserModel user, ChannelProvider channelProvider) {
  return showModalBottomSheet(
    backgroundColor: kPrimaryColor,
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: SizedBox(
          height: 234,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BottomSheetTileWidget(
                text: "Update Group Detail",
                icon: Icons.edit,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chat/edit');
                },
              ),
              BottomSheetTileWidget(
                text: "Exit Group",
                icon: Icons.exit_to_app,
                onTap: () async {
                  Navigator.pop(context);
                  await channelProvider.leaveChannel();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    ModalRoute.withName('/chat'),
                  );
                },
              ),
              if (channelProvider.createdBy == "You")
                BottomSheetTileWidget(
                  // color: Colors.red,
                  text: "Delete Group",
                  icon: Icons.delete,
                  onTap: () async {
                    Navigator.pop(context);
                    channelProvider.deleteChannel();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      ModalRoute.withName('/chat'),
                    );
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}