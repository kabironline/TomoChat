import 'dart:ui';

import 'package:TomoChat/constants.dart';
import 'package:TomoChat/providers/channel.dart';
import 'package:TomoChat/utils/dynamic2string_list.dart';
import 'package:TomoChat/widgets/bottom_sheet_tile.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future messageBottomSheet(
  BuildContext context,
  ChannelProvider channelProvider,
  DocumentReference messageId,
  String message,
  bool sender,
  List<dynamic>? links,
) {
  return showModalBottomSheet(
    backgroundColor: kPrimaryColor,
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3,
          sigmaY: 3,
        ),
        child: SizedBox(
          height: links?.isNotEmpty ?? false
              ? null
              : sender
                  ? 160
                  : 80,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (sender)
                  BottomSheetTileWidget(
                    text: "Delete Message",
                    icon: Icons.delete,
                    onTap: () async {
                      await channelProvider.deleteMessage(messageId);
                      Navigator.pop(context);
                    },
                  ),
                BottomSheetTileWidget(
                  text: "Copy Message",
                  icon: Icons.content_copy,
                  onTap: () {
                    channelProvider.copyMessage(message);
                    Navigator.pop(context);
                  },
                ),
                if (links != null)
                  for (var link in dynamic2StringList(links))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kDefaultPaddingHalf,
                      ),
                      child: AnyLinkPreview(
                        errorWidget: const SizedBox(),
                        removeElevation: true,
                        displayDirection: UIDirection.uiDirectionHorizontal,
                        titleStyle: kHeadingTextStyle,
                        bodyStyle: kSubTextStyle,
                        backgroundColor: kSecondaryColor,
                        link: link,
                        showMultimedia: true,
                        cache: const Duration(days: 7),
                        placeholderWidget:
                            const Center(child: Text("Loading...")),
                      ),
                    ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
