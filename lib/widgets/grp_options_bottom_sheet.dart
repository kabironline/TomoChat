import 'dart:ui';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/views/home_page.dart';
import 'package:TomoChat/widgets/bottom_sheet_tile.dart';
import 'package:TomoChat/widgets/size_transition.dart';
import 'package:flutter/material.dart';

Future grpDetailBottomSheet(
    BuildContext context, UserModel user, ChannelProvider channelProvider) {
  return showModalBottomSheet(
    backgroundColor: kPrimaryColor,
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: SizedBox(
          height: (channelProvider.isAdmin! ? 234 : 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (channelProvider.isAdmin!)
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
                    FadeRoute(page: const HomePage()),
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
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 3,
                              sigmaY: 3,
                            ),
                            child: AlertDialog(
                              backgroundColor: kSecondaryColor,
                              title: Text("Delete Group", style: kHeadingTextStyle,),
                              content: Text(
                                  "Are you sure you want to delete this group? This action cannot be undone.", style: kSubHeadingTextStyle,),
                              actions: [
                                TextButton(
                                  child: Text("Cancel", style: kSubHeadingTextStyle),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text("Delete", style: kSubHeadingTextStyle),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await channelProvider.deleteChannel();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      FadeRoute(
                                          page: const HomePage()),
                                      ModalRoute.withName('/chat'),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}
