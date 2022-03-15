import 'dart:ui';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/chat_modals.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/widgets/action_button.dart';
import 'package:TomoChat/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future GrpBottomSheet(
    BuildContext context, UserModel user, ChannelProvider channel) {
  return showModalBottomSheet(
    context: context,
    elevation: 0,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: kDefaultPadding),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 125,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      bottom: 0,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: kPrimaryColor,
                      ),
                    ),
                    profilePictureWidget(size: 100, imageSrc: user.image),
                  ],
                ),
              ),
              Container(
                color: kPrimaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPaddingHalf,
                        horizontal: kDefaultPadding,
                      ),
                      child: Text(
                        "${user.name}",
                        style: kHeadingTextStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActionButton(
                              onPressed: () async {
                                await channel.checkDMChannel(user.uid);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              icon: Icons.message,
                              text: "Message"),
                          const SizedBox(width: kDefaultPadding),
                          ActionButton(
                            onPressed: () {
                              var url = "tel:${user.phoneNumber}";
                              launch(url);
                            },
                            icon: Icons.call,
                            text: "   Call   ",
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                    ),

                    BottomSheetTileWidget(
                      text: "Remove User",
                      icon: Icons.person_remove,
                      onTap: () {},
                    ),
                    if (channel.channel!.admins!.contains(user.uid))
                      BottomSheetTileWidget(
                        text: "Remove Admin",
                        icon: Icons.remove_moderator,
                        onTap: () {
                          channel.removeAdmin(user.uid);
                          Navigator.pop(context);
                        },
                      ),
                    if (!channel.channel!.admins!.contains(user.uid))
                    BottomSheetTileWidget(
                      text: "Make Admin",
                      icon: Icons.add_moderator,
                      onTap: () {
                        channel.addAdmin(user.uid);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class BottomSheetTileWidget extends StatelessWidget {
  String text;
  IconData icon;
  Function? onTap;
  BottomSheetTileWidget({required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        margin: const EdgeInsets.all(kDefaultPaddingHalf),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: kSecondaryColor,
        ),
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            Text(
              text,
              style: kSubHeadingTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
