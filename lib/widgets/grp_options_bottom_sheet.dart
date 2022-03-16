import 'dart:io';
import 'dart:ui';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/modals/user_modals.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/widgets/bottom_sheet_tile.dart';
import 'package:TomoChat/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future GrpDetailBottomSheet(
    BuildContext context, UserModel user, ChannelProvider channelProvider) {
  File? image;
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
              BottomSheetTileWidget(text: "Update Group Detail", icon: Icons.edit),
              BottomSheetTileWidget(text: "Exit Group", icon: Icons.exit_to_app),
              if (channelProvider.createdBy == "You")
                BottomSheetTileWidget(
                  text: "Delete Group",
                  icon: Icons.delete,
                ),
            ],
          ),
        ),
      );
    },
  );
}
